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
