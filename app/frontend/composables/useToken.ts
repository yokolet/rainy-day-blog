import { useSessionStorage } from '@vueuse/core';
import { Ref } from 'vue';
export const JWT_STORAGE_KEY = 'rainy-day-blog-jwt';

interface UseToken {
  getJWT: () => string;
  saveJWT: (jwtToSave: string | null) => void;
  removeJWT: () => void;
}

export const useToken = (): UseToken => {
  const token: Ref<string | null> = useSessionStorage<string>(JWT_STORAGE_KEY, null);
  const getJWT = () => {
    return token.value;
  };

  const saveJWT = (jwtToSave: string) => {
    token.value = jwtToSave;
  }

  const removeJWT = () => {
    token.value = null;
  }

  return { getJWT, saveJWT, removeJWT }
}
