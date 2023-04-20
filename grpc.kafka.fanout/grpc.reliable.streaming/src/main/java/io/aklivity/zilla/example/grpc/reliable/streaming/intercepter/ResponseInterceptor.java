/*
 * Copyright 2021-2022 Aklivity. All rights reserved.
 */
package io.aklivity.zilla.example.grpc.reliable.streaming.intercepter;

import java.nio.ByteBuffer;
import java.util.logging.Level;
import java.util.logging.Logger;

import io.aklivity.zilla.example.grpc.reliable.streaming.FanoutMessage;
import io.grpc.CallOptions;
import io.grpc.Channel;
import io.grpc.ClientCall;
import io.grpc.ClientInterceptor;
import io.grpc.ForwardingClientCall;
import io.grpc.ForwardingClientCallListener;
import io.grpc.Metadata;
import io.grpc.MethodDescriptor;

public class ResponseInterceptor implements ClientInterceptor
{
    private static final int LAST_MESSAGE_FIELD_ID = 32767;

    private static final Logger LOGGER = Logger.getLogger(ResponseInterceptor.class.getName());

    private byte[] lastMessageId;

    public byte[] lastMessageId()
    {
        return lastMessageId;
    }

    public <ReqT, RespT> ClientCall<ReqT, RespT> interceptCall(
        final MethodDescriptor<ReqT, RespT> methodDescriptor,
        final CallOptions callOptions,
        final Channel channel)
    {

        return new ForwardingClientCall.SimpleForwardingClientCall<>(
            channel.newCall(methodDescriptor, callOptions))
        {

            @Override
            public void start(Listener<RespT> responseListener, Metadata headers)
            {
                super.start(
                    new ForwardingClientCallListener.SimpleForwardingClientCallListener<>(
                        responseListener)
                    {
                        @Override
                        public void onMessage(RespT message)
                        {
                            LOGGER.log(Level.FINE, "Received response from Server: {}", message);
                            ByteBuffer buffer = ((FanoutMessage) message).getUnknownFields()
                                .getField(LAST_MESSAGE_FIELD_ID)
                                .getLengthDelimitedList().get(0).asReadOnlyByteBuffer();
                            lastMessageId = new byte[buffer.capacity()];
                            buffer.get(lastMessageId, 0, buffer.capacity());
                            super.onMessage(message);
                        }
                    },
                    headers);
            }
        };
    }
}
