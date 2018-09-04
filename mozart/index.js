const async = require('async');
const google = require('googleapis');
const k8s = require('kubernetes-client');

const container = google.container('v1');

const PROJECT_ID = 'chuspace-210609';
const ZONE = 'europe-west1';
const CLUSTER_ID = 'chuspace-staging';
const NAMESPACE = 'default';

// Map from repo name to kubernetes deployment name.
const REPO_DEPLOYMENT_MAP = {
  'web': 'web',
  'web': 'worker',
  'mobius': 'mobius'
};

module.exports.subscribe = function subscribe(event, callback) {
  const pubsubMessage = event.data;
  const build = JSON.parse(Buffer.from(pubsubMessage.data, 'base64').toString());

  if (build.status !== 'SUCCESS') {
    return callback();
  }

  const newImage = build.images[0];
  const repoName = build.source.repoSource.repoName;
  const deployment = REPO_DEPLOYMENT_MAP[repoName];
  if (!deployment) {
    console.error(`The repoName ${repoName} has no deployment associated.`)
    return callback();
  }

  console.log(`Deploying '${newImage}' to '${deployment}'`)

  async.auto({
    auth: function(callback) {
      google.auth.getApplicationDefault(function(err, authClient) {
        if (err) {
          return callback(err);
        }
        if (authClient.createScopedRequired && authClient.createScopedRequired()) {
          var scopes = ['https://www.googleapis.com/auth/cloud-platform'];
          authClient = authClient.createScoped(scopes);
        }
        return callback(null, authClient);
      });
    },
    getCluster: ['auth', function(results, callback) {
      container.projects.zones.clusters.get({
        projectId: PROJECT_ID,
        zone: ZONE,
        clusterId: CLUSTER_ID,
        auth: results.auth,
      }, callback);
    }],
    setImage: ['getCluster', (results, callback) => {
      const cluster = results.getCluster;
      const endpoint = 'https://' + cluster.endpoint;
      const ext = new k8s.Extensions({
        url: endpoint,
        version: 'v1beta1',
        insecureSkipTlsVerify: true,
        namespace: NAMESPACE,
        auth: {
          bearer: results.auth.credentials.access_token
        },
      });

      const patch = { spec: { template: { spec: { containers: [ {
        name: deployment,
        image: newImage
      } ] } } } };

      ext.namespaces.deployments(deployment).patch({
        body: patch,
      }, callback);
    }],
  }, function(err, results) {
    console.log('Kubernetes image set:', err, results.setImage.spec.template.spec.containers[0].image);
    callback(err);
  });
};
