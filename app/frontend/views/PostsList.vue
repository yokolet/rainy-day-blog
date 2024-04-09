<script setup lang="ts">
import { PostsItem, usePosts } from '../composables/usePosts';
import { ComputedRef } from 'vue';
const { result, loading, error } = usePosts();
</script>

<template>
  <div class="grid">
    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
      <div v-if="loading">Loading...</div>
      <div v-else-if="error">Error {{ error.message }}</div>
      <div v-else-if="result && result.posts">
        <table class="table table-auto text-md sm:text-sm w-full">
          <tbody>
          <tr class="hover" v-for="post of result.posts" :key="post.id">
            <td class="font-bold">{{ post.title }}</td>
            <td>{{ post.excerpt }}...</td>
            <td>{{ post.identifier }}</td>
            <td><font-awesome-icon :icon="['far', 'comments']" /> {{ post.commentCount }}</td>
            <td>{{ post.updatedAt }}</td>
            <td>
              <router-link :to="`/post/${post.id}`">
                <button>
                  <font-awesome-icon :icon="['fas', 'circle-chevron-right']" size="lg" />
                </button>
              </router-link>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

    </div>
    <div class="flex sm:py-2.5 justify-center">
      <div class="join">
        <button class="join-item btn xs:btn-xs btn-active">1</button>
        <button class="join-item btn xs:btn-xs">2</button>
        <button class="join-item btn xs:btn-xs">3</button>
        <button class="join-item btn xs:btn-xs">4</button>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
