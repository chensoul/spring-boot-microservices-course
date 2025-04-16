package com.sivalabs.bookstore.webapp.client;

import com.sivalabs.bookstore.webapp.ApplicationProperties;
import com.sivalabs.bookstore.webapp.client.catalog.CatalogServiceClient;
import com.sivalabs.bookstore.webapp.client.order.OrderServiceClient;
import org.springframework.boot.http.client.ClientHttpRequestFactoryBuilder;
import org.springframework.boot.http.client.ClientHttpRequestFactorySettings;
import org.springframework.boot.web.client.RestClientCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.support.RestClientAdapter;
import org.springframework.web.service.invoker.HttpServiceProxyFactory;

import java.time.Duration;

@Configuration
class ClientConfig {
    private final ApplicationProperties properties;

    ClientConfig(ApplicationProperties properties) {
        this.properties = properties;
    }

    @Bean
    RestClientCustomizer restClientCustomizer() {
        return restClientBuilder -> restClientBuilder
                .baseUrl(properties.apiGatewayUrl())
                .requestFactory(ClientHttpRequestFactoryBuilder.detect().build(ClientHttpRequestFactorySettings.defaults()
                        .withConnectTimeout(Duration.ofSeconds(5))
                        .withReadTimeout(Duration.ofSeconds(5))));
    }

    @Bean
    CatalogServiceClient catalogServiceClient(RestClient.Builder builder) {
        RestClient restClient = builder.build();
        HttpServiceProxyFactory factory = HttpServiceProxyFactory.builderFor(RestClientAdapter.create(restClient))
                .build();
        return factory.createClient(CatalogServiceClient.class);
    }

    @Bean
    OrderServiceClient orderServiceClient(RestClient.Builder builder) {
        RestClient restClient = builder.build();
        HttpServiceProxyFactory factory = HttpServiceProxyFactory.builderFor(RestClientAdapter.create(restClient))
                .build();
        return factory.createClient(OrderServiceClient.class);
    }
}
