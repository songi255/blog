## How to use

```bash
source env.sh
```

Then you can use the `run <command>` to run the commands. (use `tab` to autocomplete)

- `run dev` : Run the development server ([http://localhost:4000](http://localhost:4000))
- `run deploy` : Deploy the site to GitHub Pages
- `run draft` : Create a new draft
- `run publish` : Publish a draft
- `run unpublish` : Unpublish a post
- `run rename` : Rename a post
- `run page` : Create a new page
- `run delete` : Delete a post

## Git workflow

Summary: Manage the source version easily in the `main` branch. Only use the `run deploy` command to manipulate the `gh-pages` branch.

- The `main` branch is just for managing the source code, so you can edit and commit freely. It does not automatically deploy.
- The `gh-pages` branch is for deployment. When you push to GitHub, the site is automatically deployed from this branch.
  - When you run the `run deploy` command, it builds the site from the current source (not directly from `main`) and pushes only the `_site` folder to the `gh-pages` branch.

## References

- [Jekyll Compose](https://github.com/jekyll/jekyll-compose)
- [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes)
  - [Docs](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/)
  - [Demo](https://mmistakes.github.io/minimal-mistakes/collection-archive/)
