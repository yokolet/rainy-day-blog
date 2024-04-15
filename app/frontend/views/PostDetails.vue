<script setup lang="ts">
import { useRoute } from 'vue-router';
import { usePost } from '../composables/usePost';
import { useDFS } from '../composables/useDFS';
import { computed } from 'vue';

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

const elements = computed(() => useDFS(result.value.post.comments));
const comment = (id: string) => result.value.post.comments.filter((c) => c["id"] === id)[0];
const indent = (level: number) => level === 0 ? "mt-1 ml-0" : `mt-0 ml-${level * 10}`;
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
          <div v-for="element in elements" :key="element['id']" :set="cur=comment(element['id'])">
            <div
                class="flex justify-between border rounded-md md:w-3/4 sm:w-full mb-0"
                :class="indent(element['level'])">
              <div class="p-3">
                <div class="flex gap-3 items-center">
                  <div class="text-sm font-bold text-gray-500">
                    {{ cur["identifier"] }}
                  </div>
                </div>
                <p class="text-gray-800 mt-2">
                  {{ cur["body"] }}
                </p>
                <button class="text-sm text-right text-blue-500">Reply</button>
              </div>
            </div>
          </div>
        </div>
        <div class="card-actions">
          <div class="w-full px-3 mt-2">
            <textarea
                class="textarea-secondary bg-gray-100 rounded border leading-normal resize-none w-full h-20 py-2 px-3
              text-sm font-medium focus:outline-none focus:bg-white"
                name="body"
                placeholder="Comment (max 300 characters)"
                maxlength="300"
                required></textarea>
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
