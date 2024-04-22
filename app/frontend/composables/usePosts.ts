import { useQuery } from '@vue/apollo-composable';
import { POSTS_QUERY } from '../graphql/queries';

export const usePosts = () => {
  const { result, loading, error } = useQuery(POSTS_QUERY);
  return {
    result,
    loading,
    error
  }
}
