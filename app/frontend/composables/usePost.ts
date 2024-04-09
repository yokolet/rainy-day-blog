import { useQuery } from '@vue/apollo-composable';
import { POST_QUERY } from '../graphql/queries';
import { computed, ComputedRef, ref } from 'vue';

interface UserItem {
  id: number;
  identifier: string;
  provider: string;
  name?: string;
  updatedAt: Date;
  createdAt: Date;
}

interface CommentItem {
  id: number;
  body: string;
  postId: number;
  replyId?: number;
  updatesAt: Date;
  userId: number;
  identifier: string;
}

interface PostItem {
  id: number;
  title: string;
  content: string;
  comments: [CommentItem] | [];
  updatedAt: Date;
  user: UserItem;
}

export const usePost = (id: string) => {
  const variables = ref({
    id
  })
  const { result, loading, error } = useQuery(POST_QUERY, variables);
  return {
    result,
    loading,
    error
  }
}
