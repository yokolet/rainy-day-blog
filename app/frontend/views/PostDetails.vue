<script setup lang="ts">
import { useRoute } from 'vue-router';
import { usePost } from '../composables/usePost';

const route = useRoute();
const { result, loading, error } = usePost(route.params.id as string);

const providerIcon = (provider: string) => {
  switch (provider) {
    case 'twitter':
      return ['fab', 'twitter'];
    case 'gitlab':
      return ['fab', 'gitlab'];
    case 'github':
      return ['fab', 'github'];
    default:
      return ['fas', 'question'];
  }
}
</script>

<template>
<div class="card w-full bg-base-100 shadow-xl">
  <div class="card-body">
    <div v-if="loading">Loading...</div>
    <div v-else-if="error">Error {{ error.message }}</div>
    <div v-else-if="result && result.post">
      <div class="text-sm font-bold text-gray-500 pb-2">
        {{ result.post.user.identifier }}
        <font-awesome-icon :icon="providerIcon(result.post.user.provider)" />
        <span class="font-light pl-2">{{ result.post.updatedAt }}</span>
      </div>
      <h2 class="card-title">{{ result.post.title }}</h2>
      <p class="pt-2">{{ result.post.content }}</p>
      <div class="divider"></div>
      <div class="w-fullbg-white p-1 md:p-3 m-2">
        <h3 class="font-semibold p-1">Comments</h3>
        <div class="flex flex-col gap-5 m-3">
          <!-- Comment Container -->
          <div>
            <div class="flex justify-between border rounded-md">
              <div class="p-3">
                <div class="flex gap-3 items-center">
                  <div class="text-sm font-bold text-gray-500">
                    User 1
                  </div>
                </div>
                <p class="text-gray-800 mt-2">
                  this is sample comment
                </p>
                <button class="text-sm text-right text-blue-500">Reply</button>
              </div>
            </div>
            <!-- Reply Container  -->
            <div class="text-gray-300 font-bold pl-16">|</div>
            <div class="flex justify-between border rounded-md ml-5">
              <div class="p-3">
                <div class="flex gap-3 items-center">
                  <h3 class="text-sm font-bold text-gray-500">
                    User 2
                  </h3>
                </div>
                <p class="text-gray-800 mt-2">
                  this is sample comment
                </p>
                <button class="text-sm text-right text-blue-500">Reply</button>
              </div>
            </div>
            <!-- END Reply Container  -->
            <!-- Reply Container  -->
            <div class="text-gray-300 font-bold pl-20">|</div>
            <div class="flex justify-between border rounded-md ml-10">
              <div class="p-3">
                <div class="flex gap-3 items-center">
                  <h3 class="text-sm font-bold text-gray-500">
                    User 3
                  </h3>
                </div>
                <p class="text-gray-800 mt-2">
                  this is sample comment
                </p>
                <button class="text-sm text-right text-blue-500">Reply</button>
              </div>
            </div>
            <!-- END Reply Container  -->
          </div>
          <!-- END Comment Container  -->
          <!-- Reply Container  -->
          <div class="flex w-full justify-between border rounded-md">
            <div class="p-3">
              <div class="flex gap-3 items-center">
                <h3 class="text-sm font-bold text-gray-500">
                  User 4
                </h3>
              </div>
              <p class="text-gray-800 mt-2">
                this is sample commnent
              </p>
              <button class="text-sm text-right text-blue-500">Reply</button>
            </div>
          </div>
          <!-- END Reply Container  -->
        </div>
        <div class="card-actions">
          <div class="w-full px-3 mt-2">
            <textarea
                class="bg-gray-100 rounded border border-gray-400 leading-normal resize-none w-full h-20 py-2 px-3
              text-sm font-medium placeholder-gray-400 focus:outline-none focus:bg-white"
                name="body" placeholder="Comment" required></textarea>
          </div>
          <div class="w-full flex justify-end px-3">
            <button class="btn btn-xs sm:btn-sm btn-outline btn-secondary">Post Comment</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>

</style>
