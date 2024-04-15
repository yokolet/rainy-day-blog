import { CommentItem } from '../types/graphqlTypes';
import { commentElements, commentTree } from '../types/commentTypes';

const buildAdj = (comments: CommentItem[]) => {
  let tree = {}
  let roots = [];
  comments.forEach((comment) => {
    if (!tree.hasOwnProperty(Number(comment["id"]))) {
      tree[Number(comment["id"])] = []
    }
    if (comment["replyId"] === null) {
      roots.push(comment.id);
      return;
    };
    if (!tree.hasOwnProperty(comment["replyId"])) {
      tree[comment["replyId"]] = []
    }
    tree[comment["replyId"]].push(comment.id)
  })
  return {
    roots,
    tree,
  }
}

const dfs = (root: string, adj: commentTree, result: commentElements) => {
  const visited = [];
  const stack = [{id: root, level: 0}];
  while (stack.length > 0) {
    let { id, level } = stack.pop();
    if (!visited.includes(id)) {
      visited.push(id);
      result.push({ id, level });
    }
    adj[id].forEach((cur) => {
      if (!visited.includes(cur)) stack.push({id: cur, level: level + 1})
    });
  }
}

export const useDFS = (comments: CommentItem[]): commentElements => {
  let {roots, tree} = buildAdj(comments);
  const result = [];
  roots.forEach((root) => dfs(root, tree, result));
  return result;
}
