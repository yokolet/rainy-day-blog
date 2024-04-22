<script setup lang="ts">
import { usePosts } from '../composables/usePosts';
import { ref } from 'vue';
import { PostInputType } from '../types/formInputTypes';
import { useEscapeHtml } from '../composables/useEscapeHtml';
import { usePostCreate } from '../composables/usePostCreate';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';

const store = useAuthStore();
const { result, loading, error } = usePosts();
const router = useRouter();

const postInput = ref<PostInputType>({
  title: {
    text: "",
    isValid: true,
  },
  content: {
    text: "",
    isValid: true,
  }
});

const postCreateError = ref<string|null>(null);

const hasAlert = ref<boolean>(false);
const alertMessage = ref<string>('Something went wrong.');
const resetAlert = () => {
  hasAlert.value = false;
  router.push('/');
}

const validateInput = (key: string): boolean => {
  postInput.value[key].isValid = postInput.value[key].text.length > 0;
  return postInput.value[key].isValid;
}

const clearPostInput = () => {
  postInput.value['title'] = { text: "", isValid: true };
  postInput.value['content'] = { text: "", isValid: true };
}

const createNewPost = () => {
  let isValidTitle = validateInput('title');
  let isValidContent = validateInput('content');
  if (isValidTitle && isValidContent) {
    const { postCreate, onDone, onError } = usePostCreate(
        useEscapeHtml(postInput.value['title'].text),
        useEscapeHtml(postInput.value['content'].text)
    );
    postCreate();
    onDone(createResult => {
      hasAlert.value = true;
      alertMessage.value = 'Success.';
    });
    onError( createError => {
      postCreateError.value = createError.message;
      console.log(`post create error: ${postCreateError.value}`);
      hasAlert.value = true;
      alertMessage.value = 'Log in again. Log out first if it needs.';
    });
  }
}

const submitPostInput = (event: Event) => {
  switch ((event as SubmitEvent).submitter.id) {
    case 'clear':
      clearPostInput();
      break;
    case 'create':
      createNewPost();
      break;
    default:
      () => console.log('invalid event');
      break;
  }
}

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
<!--    <div class="flex sm:py-2.5 justify-center">-->
<!--      <div class="join">-->
<!--        <button class="join-item btn xs:btn-xs btn-active">1</button>-->
<!--        <button class="join-item btn xs:btn-xs">2</button>-->
<!--        <button class="join-item btn xs:btn-xs">3</button>-->
<!--        <button class="join-item btn xs:btn-xs">4</button>-->
<!--      </div>-->
<!--    </div>-->
    <div class="flex justify-end bottom-14 w-full">
      <button v-if="store.isAuthenticated()" class="text-indigo-700" onclick="post_form.showModal()">
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
        <form class="mt-4 p-4" @submit.prevent="submitPostInput($event)">
          <label class="form-control">
            <div class="label">
              <span class="label-text">Title</span>
              <span class="label-text-alt">max 50 characters</span>
            </div>
            <input
                type="text"
                class="input input-bordered"
                placeholder="Awesome title"
                minlength="1"
                maxlength="50"
                v-model.trim="postInput['title'].text" />
            <div v-if="!postInput['title'].isValid" class="label-text text-red-900">
              Title must not be-empty.
            </div>
          </label>
          <label class="form-control">
            <div class="label">
              <span class="label-text">Content</span>
              <span class="label-text-alt">max 1000 characters</span>
            </div>
            <textarea
                class="textarea textarea-bordered h-24"
                placeholder="Write something awesome"
                minlength="1"
                maxlength="1000"
                v-model.trim="postInput['content'].text"
            ></textarea>
            <div v-if="!postInput['content'].isValid" class="label-text text-red-900">
              Content must not be-empty.
            </div>
          </label>
          <div v-if="hasAlert" role="alert" class="alert mt-2">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-info shrink-0 w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <span>{{ alertMessage }}</span>
            <div>
              <button class="btn btn-sm btn-primary" onclick="post_form.close()" @click="resetAlert">OK</button>
            </div>
          </div>
          <div v-else class="modal-action">
            <button id="clear" class="btn btn-accent btn-outline btn-xs sm:btn-sm">Clear</button>
            <button id="create" class="btn btn-secondary btn-outline btn-xs sm:btn-sm">Create</button>
          </div>
        </form>
      </div>
    </dialog>
  </div>
</template>

<style scoped>

</style>
