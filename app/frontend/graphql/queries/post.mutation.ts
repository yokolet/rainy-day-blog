import gql from 'graphql-tag';

export const POST_MUTATION = gql`
  mutation post($title: String!, $content: String!) {
    postCreate(input: {
      title: $title,
      content: $content
    }) {
      post {
        id
        title
        content
        updatedAt
        user {
          id
          identifier
          provider
        }
      }
    }
  }
`;
