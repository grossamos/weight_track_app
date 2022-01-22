Taken from https://gitlab.com/fdroid/fdroiddata/-/blob/master/CONTRIBUTING.md:

1. Create account on [GitLab](https://about.gitlab.com/).
2. Visit and fork the [fdroiddata](https://gitlab.com/fdroid/fdroiddata) repository.
3. On local machine, clone your fork.
4. Create and checkout a new branch. Name it `com.amosgross.weight_track_app`.
5. Add the `com.amosgross.weight_track_app.yml` file.
6. Commit and push to your upstream fork.
7. Go to the `CI/CD` menu in the GitLab project of your fork.
8. Check if the pipeline for your commit(s) succeed. If not, take a look into the logs and try to fix the error by editing the metadata file again.
9. If everything went fine, you can create a new [merge request](https://gitlab.com/fdroid/fdroiddata/-/merge_requests) at the `fdroiddata` repository.
10. Now wait for the packagers to pick up your Merge Request. Please keep track if they asked any questions and reply to them as soon as possible.
