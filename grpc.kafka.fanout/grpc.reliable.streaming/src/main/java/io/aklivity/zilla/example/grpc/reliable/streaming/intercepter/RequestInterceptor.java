/*
 * Copyright 2021-2022 Aklivity. All rights reserved.
 */
package io.aklivity.zilla.example.grpc.reliable.streaming.intercepter;

import io.grpc.CallOptions;
import io.grpc.Channel;
import io.grpc.ClientCall;
import io.grpc.ClientInterceptor;
import io.grpc.ForwardingClientCall;
import io.grpc.Metadata;
import io.grpc.MethodDescriptor;

public class RequestInterceptor implements ClientInterceptor
{
    private final ResponseInterceptor responseInterceptor;

    public RequestInterceptor(
        ResponseInterceptor responseInterceptor)
    {

        this.responseInterceptor = responseInterceptor;
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
            public void start(ClientCall.Listener<RespT> responseListener, Metadata headers)
            {
                final byte[] lastMessageId = responseInterceptor.lastMessageId();

                if (lastMessageId != null)
                {
                    headers.put(Metadata.Key.of("last-message-id-bin", Metadata.BINARY_BYTE_MARSHALLER), lastMessageId);
                }

                super.start(responseListener, headers);
            }
        };
    }
}

