const escapeMap: Record<string, string> = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&#39;'
};

const reg = /[&<>"']/gi;

export const useEscapeHtml = (text: string): string => {
  return text.replace(reg, (match) => escapeMap[match]);
};
