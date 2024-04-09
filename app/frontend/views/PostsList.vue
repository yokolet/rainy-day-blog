<script setup lang="ts">
import { useQuery } from '@vue/apollo-composable';
import { POSTS_QUERY } from '../graphql/queries';
import { computed } from 'vue';

const { result } = useQuery(POSTS_QUERY);
const posts  = computed(() => result.value ?? [])

console.log(posts)
</script>

<template>
  <div class="grid">
    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
      <table class="table table-auto text-md sm:text-sm w-full">
        <tbody>
        <tr class="hover" v-for="post of posts['posts']" :key="post.id">
          <td class="font-bold">{{ post.title }}</td>
          <td>{{ post.excerpt }}...</td>
          <td>{{ post.identifier }}</td>
          <td><font-awesome-icon :icon="['far', 'comments']" /> {{ post.commentCount }}</td>
          <td>{{ post.updatedAt }}</td>
          <td>
            <button>
              <font-awesome-icon :icon="['fas', 'circle-chevron-right']" size="lg" />
            </button>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
    <div class="relative sm:py-2.5">
      <div class="join">
        <button class="join-item btn xs:btn-xs">1</button>
        <button class="join-item btn xs:btn-xs btn-active">2</button>
        <button class="join-item btn xs:btn-xs">3</button>
        <button class="join-item btn xs:btn-xs">4</button>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
