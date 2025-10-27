# Pocketbase migration

If you are running a version of the Cactus Backend before 0.2.0 (Helm chart version
below 0.5.0), it is based on Pocketbase. Startig from version 0.2.0 (Helm chart version
0.5.0), Cactus Backend uses a separate Postgres database instead of Pocketbase's built-in
SQLite database to enable better scalability and reliability.

To migrate your existing Pocketbase data to PostgreSQL so you can use the new Cactus Backend
version, follow these steps:

1. Deploy the new Cactus Backend version (0.2.0 or later) alongside your existing
   Pocketbase-based Cactus Backend. Make sure both versions are running simultaneously.

2. Copy the `data.db` file from the Pocketbase pod to your local machine.
```
kubectl exec cactus-backend-old-0 -- cat /app/data/pb_data/data.db > ./cactus-backend-old-0-data.db
```

3. Copy the `data.db` file to the new backend pod.
```
kubectl cp ./cactus-backend-old-0-data.db cactus-backend-new-0:/app/data/cactus-backend-old-0-data.db
```

4. Run the migration command in a pod running the new backend version.
   Set `POCKETBASE_URL` to an address where the old Pocketbase can be reachable as it's needed
   to access old semantic history which is stored as files instead of in the SQLite .db file.
   You can use the internal Kubernetes service name of the old backend, an IP address of
   a pod running the old backend, or an external address if you have exposed the old backend
   outside the cluster.
```
kubectl exec -it cactus-backend-new-0 -- bash
SQLITE_URL=sqlite:data/cactus-backend-old-0-data.db POCKETBASE_URL=http://cactus-backend-old:8090 ./migrate_pb
```
