import { useQuery } from '@vue/apollo-composable';
import { POSTS_QUERY } from '../graphql/queries';
import { computed, ComputedRef } from 'vue';

export interface PostsItem {
  id: number;
  title: string;
  excerpt: string;
  commentCount: number;
  updatedAt: Date;
  identifier: string;
}

export const usePosts = () => {
  const { result, loading, error } = useQuery(POSTS_QUERY);
  return {
    result,
    loading,
    error
  }
}
