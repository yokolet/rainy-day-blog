## Frontend: Vue Setup

To use Vue on Rails, the common way is to use vite_rails gem.
Vite is a framework independent development tool.
Vue will be installed by Vite's Vue plugin.

### Install Vite

```bash
$ bundle add vite_rails
$ bundle exec vite install
```

### Switch from npm to Bun
The vite_rails gem uses npm to install vite.
It works, but Bun runs much faster.

```bash
$ rm package-lock.json
$ bun install
```

### Install Vue, Vue Plugin and TypeScript

Update package.json as in below:
```json
{
  "scripts": {
    "dev": "bunx --bun vite",
    "build": "vue-tsc && bunx --bun vite build",
    "preview": "bunx --bun vite preview"
  },
  "dependencies": {
    "vue": "^3.4.21"
  },
  "devDependencies": {
    "vite-plugin-ruby": "^5.0.0",
    "@vitejs/plugin-vue": "^5.0.4",
    "typescript": "^5.4.2",
    "vite": "^5.1.6",
    "vue-tsc": "^2.0.6"
  }
}
```

Run bun command to install packages.
```bash
$ bun install
```

Configure Vue plugin.
```typescript
// vite.config.ts

import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue(),
  ],
})
```

Create tsconfig.json and tsconfig.node.json with the content blow:
- tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "module": "ESNext",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "preserve",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src/**/*.ts", "src/**/*.d.ts", "src/**/*.tsx", "src/**/*.vue"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```
- tsconfig.node.json
```json
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
```

### Set up Starter Command

- Procfile.dev\
Replace the content in `Procfile.dev` with two lines below:
```bash
web: env RUBY_DEBUG_OPEN=true bin/rails server
js: bun run dev
```

- bin/dev\
Create a command `bin/dev` with the content below:
```bash
#!/usr/bin/env sh

if gem list --no-installed --exact --silent foreman; then
  echo "Installing foreman..."
  gem install foreman
fi

# Default to port 3000 if not specified
export PORT="${PORT:-3000}"

exec foreman start -f Procfile.dev "$@"
```

Change the bin/dev permission to an executable one.
For example, `chmod 755 bin/dev`.

Now, a backend and frontend servers start up by the command below:
```bash
$ bin/dev
```

### Create a Vue App Mount Point

Create a controller and view for a Vue app mount point.
```bash
$ rails g controller home index
```

Edit `app/views/pages/index.html.erb` as in blow.
```erbruby
<%= content_tag(:div, "", id:"app") %>
```

Update the route to show Vue app as a root page.

```ruby
# config/routes.rb

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
end
```

### Create a Vue App

Since the Vue app is going to use TypeScript, replaces vite_javascript_tag in
`app/views/layouts/application.html.erb` by vite_typescript_tag.
```erbruby
<%= vite_typescript_tag 'application' %>
```

Rename the entrypoint file to have .ts file extension.
```bash
$ mv app/frontend/entrypoints/application.js app/frontend/entrypoints/application.ts
```

### Install Tailwind CSS

To use Tailwind CSS with Vue, Tailwind packages should be added in a JavaScript manner.

In this app, Tailwind CSS is used only in Vue app.
Rails 7's CSS bundling feature is not necessary here.

Install and initialize Tailwind as in below:

```bash
$ bun add --dev tailwindcss postcss autoprefixer
$ bunx tailwindcss init -p
```

Once Tailwind is initialized, `tailwind.config.js` and `postcss.config.js` files are created.
Update `tailwind.config.js` to look at frontend code changes.

```javascript
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        "./index.html",
        "./app/frontend/**/*.{vue,js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {},
    },
    plugins: [],
}
```

Create a file, `app/frontend/entrypoints/index.css`, with the content below:
```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

Import the index.css in `app/frontend/entrypoints/application.ts`:
```javascript
import './index.css'
```

As for now, Tailwind classes are available to use in Vue components.

### Install daisyUI

[daisyUI](https://daisyui.com/) is a plugin for Tailwind.
It provides various components so that people can write tailwind css classes easily.

- Install a package
```bash
$ bun add -D daisyui
```

- Configure tailwind plugin\
Open `tailwind.config.js` and add daisyui plugin as in below:
```javascript
module.exports = {
  //...
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["fantasy", "winter", "light", "dark",],
  },
}
```

Above change includes a themes definition which is optional.

### Install fontawesome

[Font Awesome](https://fontawesome.com/) is a very popular icon library.
To use with Vue, Font Awesome should be installed and set up.

- Install a package
```bash
$ bun add @fortawesome/fontawesome-svg-core
$ bun add @fortawesome/vue-fontawesome
$ bun add @fortawesome/free-brands-svg-icons
$ bun add @fortawesome/free-regular-svg-icons
$ bun add @fortawesome/free-solid-svg-icons
```

- Set up Font Awesome\
Open `app/frontend/entrypoint/application.ts`
(The file is equivalent to src/main.js in a typical Vue project)
and add settings as in blow:

```javascript
//...
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { far } from '@fortawesome/free-regular-svg-icons'
import { fab } from '@fortawesome/free-brands-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
//...
library.add(fas, far, fab)

createApp(App)
    .component('font-awesome-icon', FontAwesomeIcon)
//...
```

- Usage examples
```html
<font-awesome-icon icon="fas fa-right-to-bracket" />

<font-awesome-icon icon="fab fa-twitter" />
```


### References
- Vite Ruby: [https://vite-ruby.netlify.app/](https://vite-ruby.netlify.app/)
- Vue.js Guide: [https://vuejs.org/guide/introduction.html](https://vuejs.org/guide/introduction.html)
- Build a frontend using Vite and Bun: [https://bun.sh/guides/ecosystem/vite](https://bun.sh/guides/ecosystem/vite)
- [Ruby-on-Rails and VueJS tutorial](https://bootrails.com/blog/ruby-on-rails-and-vuejs-tutorial/)
- [Create Rails-7 app with Vite](https://dev.to/chmich/setup-vite-on-rails-7-f1i)
- [Integrating Bun with Vite Ruby for Lightning-Fast Frontend Builds](https://dev.to/jetthoughts/integrating-bun-with-vite-ruby-for-lightning-fast-frontend-builds-1fh2)
- [Building a Rails App with a Vue.js Frontend](https://clouddevs.com/ruby-on-rails/building-app-with-vuejs-frontend/)
- [Vue on Rails](https://medium.com/@oscarreciogonzalez/vue-on-rails-15686b85b1d3)
- [daisyUI Docs](https://daisyui.com/components/)
- [Font Awesome: Set Up with Vue](https://docs.fontawesome.com/web/use-with/vue)
