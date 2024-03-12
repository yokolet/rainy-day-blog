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

Replace the content in Procfile.dev with two lines below:
```bash
web: env RUBY_DEBUG_OPEN=true bin/rails server
js: bun run dev
```

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
