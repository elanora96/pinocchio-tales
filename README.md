# Tales of Pinocchio

## We post scary stories for our followers

[![Netlify Status](https://api.netlify.com/api/v1/badges/5df25e3a-e177-42b6-bc71-ca4160fb0f9b/deploy-status)](https://app.netlify.com/projects/talesofpinocchio/deploys)

### [Enter if you dare](https://talesofpinocchio.netlify.app)

This is a [Zola](https://www.getzola.org/) site using the [abridge](https://github.com/Jieiku/abridge) theme

More details later, but the flake included can be used like this:

- Build the project (to `./result/public/`)

  ```sh
  nix build
  ```

- Test the project

  ```sh
  nix check
  ```

- Enter a dev shell

  ```sh
  nix develop
  ```

  - Once the enviroment is built, a hot reload server is availble with

    ```sh
    zola serve
    ```

- Format the project

  ```sh
  nix fmt
  ```

If not using Nix, install `zola` and `nodejs` seperately

- Build the project (to `./public/`)

  ```sh
  npm run build
  ```

- Hot reload server

  ```sh
  zola serve
  ```

- And uhhh, idk figure out formatting equivalent to the `treefmt-nix` settings and just make sure it builds this site is silly
