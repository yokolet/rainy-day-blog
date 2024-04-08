<script setup lang="ts">
import { useQuery } from '@vue/apollo-composable';
import { POSTS_QUERY } from '../graphql/queries';
import { computed } from 'vue';

const { result } = useQuery(POSTS_QUERY);
const posts  = computed(() => result.value ?? [])

console.log(posts)
</script>

<template>
  <div>posts list</div>
  <div class="overflow-auto">
    <table class="table">
      <tbody>
        <tr class="hover" v-for="post of posts['posts']" :key="post.id">
          <td class="font-bold">{{ post.title }}</td>
          <td>{{ post.excerpt }}...</td>
          <td>{{ post.identifier }}</td>
          <td><font-awesome-icon :icon="['far', 'comments']" /> {{ post.commentCount }}</td>
          <td>{{ post.updatedAt }}</td>
          <td><button><font-awesome-icon :icon="['fas', 'circle-chevron-right']" /></button></td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>

</style>
