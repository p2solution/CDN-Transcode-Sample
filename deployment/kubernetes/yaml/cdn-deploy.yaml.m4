include(platform.m4)
include(configure.m4)

apiVersion: apps/v1
kind: Deployment
metadata:
  name: cdn
  labels:
    app: cdn
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cdn
  template:
    metadata:
      labels:
        app: cdn
    spec:
      enableServiceLinks: false
      containers:
        - name: cdn
          image: defn(`REGISTRY_PREFIX')ovc_cdn_service:latest
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8443
            - containerPort: 1935
          resources:
            limits:
              cpu: eval(defn(`CDN_CPU')*2)
              memory: eval(defn(`CDN_MEMORY')*2)Mi
            requests:
              cpu: defn(`CDN_CPU')
              memory: defn(`CDN_MEMORY')Mi
          volumeMounts:
            - mountPath: /var/www/archive
              name: video-archive
            - mountPath: /var/www/video
              name: video-cache
            - mountPath: /var/run/secrets
              name: self-signed-certificate
              readOnly: true
      volumes:
          - name: video-archive
            persistentVolumeClaim:
               claimName: video-archive
          - name: video-cache
            persistentVolumeClaim:
               claimName: video-cache
          - name: self-signed-certificate
            secret:
               secretName: self-signed-certificate
PLATFORM_NODE_SELECTOR(`Xeon')dnl
