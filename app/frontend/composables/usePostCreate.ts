import { useMutation } from '@vue/apollo-composable';
import { POST_MUTATION } from '../graphql/queries';

export const usePostCreate = () => {
  const { mutate: postCreate, loading: postCreateLoading, onError } = useMutation(
    POST_MUTATION
  );
  return {
    postCreate,
    postCreateLoading,
    onError,
  }
}
