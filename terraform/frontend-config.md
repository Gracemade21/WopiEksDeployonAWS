apiVersion: v1
kind: ConfigMap
metadata:
  name: wopi-frontend-config
  namespace: wopi-services
data:
  OFFICE_ONLINE_SERVER_URL: "https://office.hyland.com/appserverdemo/private"
  LOGGING_LEVEL: "Information"
  vite.config.js: |
    import { defineConfig } from 'vite';

    export default defineConfig({
      server: {
        host: '0.0.0.0',
        port: 3000,
        allowedHosts: 'all',
        hmr: {
          host: 'true'
        },
        proxy: {
          '/odata': {
            target: 'http://wopi-backend-service:5001',
            changeOrigin: true,
            secure: false,
            configure: (proxy, options) => {
              proxy.on('proxyReq', (proxyReq, req, res) => {
                const isXHR = req.headers['x-requested-with'] === 'XMLHttpRequest' ||
                             req.headers['accept']?.includes('application/json') ||
                             req.headers['content-type']?.includes('application/json');

                const referer = req.headers['referer'];
                const origin = req.headers['origin'];

                if (!isXHR && !referer) {
                  proxyReq.destroy();
                  res.writeHead(403, { 'Content-Type': 'application/json' });
                  res.end(JSON.stringify({ error: 'Direct API access not allowed' }));
                }
              });
            }
          },
          '/api': {
            target: 'http://wopi-backend-service:5001',
            changeOrigin: true,
            secure: false,
            configure: (proxy, options) => {
              proxy.on('proxyReq', (proxyReq, req, res) => {
                const isXHR = req.headers['x-requested-with'] === 'XMLHttpRequest' ||
                             req.headers['accept']?.includes('application/json') ||
                             req.headers['content-type']?.includes('application/json');

                const referer = req.headers['referer'];

                if (!isXHR && !referer) {
                  proxyReq.destroy();
                  res.writeHead(403, { 'Content-Type': 'application/json' });
                  res.end(JSON.stringify({ error: 'Direct API access not allowed' }));
                }
              });
            }
          }
        }
      }
    })


















apiVersion: apps/v1
kind: Deployment
metadata:
  name: wopi-frontend
  namespace: wopi-services
  labels:
    app: wopi-frontend
    component: frontend
    version: v1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wopi-frontend
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: wopi-frontend
        component: frontend
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "3000"
    spec:
      securityContext:
        runAsNonRoot: true
        fsGroup: 1000
      containers:
        - name: frontend
          image: 116839935550.dkr.ecr.us-east-2.amazonaws.com/test-hyl-hob:frontend
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 3000
              protocol: TCP
          env:
            - name: VITE_API_SERVER_URL
              value: ""
            - name: NODE_ENV
              value: "production"
          command: ["/bin/sh", "-c"]
          args:
            - |
              # Create writable directories
              mkdir -p /tmp/.vite
              mkdir -p /tmp/node_modules

              # Copy config to writable location
              cp /config/vite.config.js /tmp/vite.config.js

              # Create environment file
              echo 'VITE_API_SERVER_URL=""' > /tmp/.env

              # Change to working directory and start
              cd /app

              # Link config and env files
              ln -sf /tmp/vite.config.js ./vite.config.js
              ln -sf /tmp/.env ./.env

              echo "Starting frontend with restricted proxy"
              npm run dev -- --config /tmp/vite.config.js
          volumeMounts:
            - name: vite-config
              mountPath: /app/vite.config.js
              subPath: vite.config.js
            - name: tmp
              mountPath: /tmp
          resources:
            requests:
              cpu: 100m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 512Mi
          securityContext:
            runAsNonRoot: true
            runAsUser: 1000
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: false
            capabilities:
              drop:
                - ALL
      volumes:
        - name: vite-config
          configMap:
            name: wopi-frontend-config
            items:
              - key: vite.config.js
                path: vite.config.js
        - name: tmp
          emptyDir: {}
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 100
              podAffinityTerm:
                labelSelector:
                  matchExpressions:
                    - key: app
                      operator: In
                      values:
                        - wopi-frontend
                topologyKey: kubernetes.io/hostname
      terminationGracePeriodSeconds: 30

