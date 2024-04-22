import { useQuery } from '@vue/apollo-composable';
import { POST_QUERY } from '../graphql/queries';
import { ref } from 'vue';

export const usePost = (id: string) => {
  const variables = ref({
    id
  });
  const { result, loading, error } = useQuery(POST_QUERY, variables);
  return {
    result,
    loading,
    error
  }
}
