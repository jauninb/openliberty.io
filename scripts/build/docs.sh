set -e
export BUILD_SCRIPTS_DIR=$(dirname $0)

echo "Begin building all doc content"

#Antora Portion of Docs
echo "Begin building of Antora portion of docs"

$BUILD_SCRIPTS_DIR/node_install.sh

$BUILD_SCRIPTS_DIR/antora_install.sh

# Use the Antora playbook to download the docs and build the doc pages
timer_start=$(date +%s)
$BUILD_SCRIPTS_DIR/antora_clone_playbook.sh

$BUILD_SCRIPTS_DIR/antora_build_docs.sh
timer_end=$(date +%s)
echo "Total execution time for cloning playbook and building docs via Antora: '$(date -u --date @$(( $timer_end - $timer_start )) +%H:%M:%S)'"

# Copy the contents generated by Antora to the website folder
echo "Moving the Antora docs to the jekyll webapp"
mv src/main/content/docs/build/site/docs/* target/jekyll-webapp/docs/

timer_start=$(date +%s)
python3 $BUILD_SCRIPTS_DIR/ToC_parse_features.py
timer_end=$(date +%s)
echo "Total execution time for parsing ToC Features: '$(date -u --date @$(( $timer_end - $timer_start )) +%H:%M:%S)'"

echo "Finished building and prepping all Antora content"

# Javadoc Portion of Docs
echo "Begin building javadoc content"
$BUILD_SCRIPTS_DIR/javadoc_clone.sh

# Move the javadocs into the web app
echo "Moving javadocs to the jekyll webapp"
mv src/main/content/docs-javadoc/modules/ target/jekyll-webapp/docs/


# Special handling for javadocs
$BUILD_SCRIPTS_DIR/javadoc_modify.sh

echo "Finished building Javadoc content"

echo "Finished building all doc content"