FROM salihciftci/liman

COPY ./healthcheck.js /

RUN chmod a+x /healthcheck.js

HEALTHCHECK CMD node /healthcheck.js
