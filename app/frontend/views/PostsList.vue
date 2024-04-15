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
    <div class="flex justify-end bottom-14 w-full">
      <button class="text-indigo-700" onclick="post_form.showModal()">
        <font-awesome-icon :icon="['fas', 'circle-plus']" size="3x" />
      </button>
    </div>
    <!-- Open the modal using ID.showModal() method -->
    <dialog id="post_form" class="modal">
      <div class="modal-box w-11/12 max-w-5xl">
        <form method="dialog">
          <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
            <font-awesome-icon :icon="['fas', 'circle-xmark']" size="xl"/>
          </button>
        </form>
        <form class="mt-4 p-4">
          <label class="form-control">
            <div class="label">
              <span class="label-text">Title</span>
            </div>
            <input
                type="text"
                class="input input-bordered"
                placeholder="Awesome title"
                minlength="1"
                maxlength="20" />
          </label>
          <label class="form-control">
            <div class="label">
              <span class="label-text">Content (max 1000 characters)</span>
            </div>
            <textarea
                class="textarea textarea-bordered h-24"
                placeholder="Write something awesome"
                minlength="1"
                maxlength="1000"></textarea>
          </label>
          <div class="modal-action">
            <button class="btn btn-accent btn-outline btn-xs sm:btn-sm">Cancel</button>
            <button class="btn btn-secondary btn-outline btn-xs sm:btn-sm">Create</button>
          </div>
        </form>
      </div>
    </dialog>
  </div>
</template>

<style scoped>

</style>
