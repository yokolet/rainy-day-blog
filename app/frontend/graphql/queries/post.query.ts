import gql from 'graphql-tag'

export const POST_QUERY = gql`
  query Posts ($id: ID!){
    post(id: $id) {
        content
        id
        title
        updatedAt
        comments {
            body
            id
            identifier
            postId
            replyId
            updatedAt
            userId
        }
        user {
            createdAt
            id
            identifier
            name
            provider
            updatedAt
        }
    }
  }
`;
