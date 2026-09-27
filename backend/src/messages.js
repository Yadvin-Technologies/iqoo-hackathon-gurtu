'use strict';

// Push texts the server writes itself, in the reader's app language. Others
// fall back to English. Reminder texts are sent as written.

const TEXT = {
  joinedTitle: {
    en: 'New member in the care circle',
    hi: 'देखभाल घेरे में नया सदस्य',
    te: 'సంరక్షణ వలయంలో కొత్త సభ్యులు',
  },
  joinedBody: {
    en: '{name} joined {patient}\'s care circle.',
    hi: '{name} अब {patient} के देखभाल घेरे में हैं।',
    te: '{name} ఇప్పుడు {patient} సంరక్షణ వలయంలో చేరారు.',
  },
};

function t(key, language, vars = {}) {
  const table = TEXT[key];
  const text = table[language] || table.en;
  return text.replace(/\{(\w+)\}/g, (_, k) => vars[k] ?? '');
}

module.exports = { t };
