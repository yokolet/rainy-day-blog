export interface UserItem {
  id: number;
  identifier: string;
  provider: string;
  name?: string;
  updatedAt: Date;
  createdAt: Date;
}

export interface CommentItem {
  id: number;
  body: string;
  postId: number;
  replyId?: number;
  updatesAt: Date;
  userId: number;
  identifier: string;
}

export interface PostItem {
  id: number;
  title: string;
  content: string;
  comments: [CommentItem] | [];
  updatedAt: Date;
  user: UserItem;
}

export interface PostsItem {
  id: number;
  title: string;
  excerpt: string;
  commentCount: number;
  updatedAt: Date;
  identifier: string;
}
