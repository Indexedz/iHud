import React from 'react'
import ReactDOM from 'react-dom/client'
import './global.css';

/* FONTAWESOME */
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { far } from '@fortawesome/free-regular-svg-icons';
library.add(fas, fab, far);

/* LAYOUTS */
import Status from './layouts/Status';
import Vehicle from './layouts/Vehicle';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <Vehicle/>
    <Status />
  </React.StrictMode>,
)
