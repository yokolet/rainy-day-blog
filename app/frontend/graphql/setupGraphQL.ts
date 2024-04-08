import { ApolloClient, createHttpLink, InMemoryCache } from '@apollo/client/core';
import { setContext } from '@apollo/client/link/context';
import { provideApolloClient } from '@vue/apollo-composable';
import { useToken } from '../composables/useToken';

const GRAPHQL_ENDPOINT = 'http://localhost:3000/graphql';

const { getJWT } = useToken();

const httpLink = createHttpLink({
  uri: GRAPHQL_ENDPOINT,
});

const authLink = setContext((_, { headers }) => {
  const authToken = getJWT();
  return authToken
    ? { headers: { ...headers, authorization: `Bearer ${authToken}` }}
    : { headers };
});

const cache = new InMemoryCache();

const apolloClient = new ApolloClient({
  link: authLink.concat(httpLink),
  cache,
});

export const setupGraphQL = (): void => {
  provideApolloClient(apolloClient);
}
