export type PostInputElement = {
  text: string;
  isValid: boolean;
}

export type PostInputType = {
  [key: string]: PostInputElement;
};
