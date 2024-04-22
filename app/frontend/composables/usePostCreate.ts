import { useMutation } from '@vue/apollo-composable';
import { POSTS_QUERY, POST_MUTATION } from '../graphql/queries';

export const usePostCreate = (title: string, content: string) => {
  const { mutate: postCreate, loading: postCreateLoading, onDone, onError } = useMutation(
    POST_MUTATION,
    () => ({
      variables: {
        title,
        content,
      },
      update: (cache, { data: { postCreate }}) => {
        let data = cache.readQuery({ query: POSTS_QUERY })
        data = {
          posts: [
            {
              __typename: "Posts",
              commentCount: 0,
              excerpt: postCreate.post.content.substring(0, 30),
              id: postCreate.post.id,
              identifier: postCreate.post.user.identifier,
              title: postCreate.post.title,
              updatedAt: postCreate.post.updatedAt,
            },
            ...data.posts,
          ],
        }
        cache.writeQuery({ query: POSTS_QUERY, data });
      }
    })
  );
  return {
    postCreate,
    postCreateLoading,
    onDone,
    onError,
  }
}
