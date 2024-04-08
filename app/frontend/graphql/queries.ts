import gql from 'graphql-tag'

export const POSTS_QUERY = gql`
  query Posts {
    posts {
        id
        identifier
        title
        excerpt
        commentCount
        updatedAt
    }
  }
`;

export const POST_QUERY = gql`
  query Posts ($id: ID!){
    post(id: $id) {
        id
        title
        content
        updatedAt
        comments {
            id
            body
            identifier
            postId
            replyId
            updatedAt
            userId
        }
        user {
            id
            identifier
            name
            provider
            createdAt
            updatedAt
        }
    }
  }
`;
