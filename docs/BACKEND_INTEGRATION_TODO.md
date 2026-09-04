# Backend Integration — What's Confirmed vs. What's Missing

This tracks the gap between the Flutter Authentication network layer (now
built and DI-wired, see `core/network/`, `core/storage/secure_storage_service.dart`,
`features/auth/data/datasources/auth_remote_data_source.dart`) and the
actual backend the Backend team provided in `docker/docker-compose.yml`
and `docker/.env`.

## Confirmed from the provided Docker package

- Services: `redis`, `sqlserver`, `flowersapp.apigateway`, `flowersapp.auth`.
- API Gateway host port: **9090** → container port 8080. Flutter's
  `ApiEndpoints.baseUrl` now defaults to `http://localhost:9090`.
- Auth service host port: **8081** → container port 8080 (Flutter should
  not call this directly — the Gateway `depends_on` the Auth service,
  meaning the Gateway is the intended entry point).
- Both services expose a health check at `/health/live` internally
  (`http://localhost:8080/health/live` inside each container) — this is
  the only endpoint path actually present anywhere in the provided files.
- The Auth service is JWT-based (`JWT_KEY` / `Jwt__Key` env vars are
  passed to it), backed by SQL Server (`FlowersApp.AuthDb`) and Redis.
- No other services (Products/Orders/Users/etc.) exist in the compose
  file — only Auth is available, matching the current Flutter scope.

## Could not be confirmed, and why

The Docker package contains **no OpenAPI/Swagger document and no source
code** — only deployment config (image names/tags, ports, DB/Redis/JWT
env vars). The backend also could not be started locally: `docker compose
pull`/`up` repeatedly failed with `context deadline exceeded` reaching
Docker Hub for `redis:alpine`, `manaarnabil/flowersapp-auth:latest`, and
`manaarnabil/flowersapp-apigateway:latest` (Docker Desktop's engine is
running; the containers list is empty — this is a registry/network
connectivity issue on this machine, not a problem with the compose file
itself). With nothing listening on :9090, there was no live Swagger page
to read either.

## What to request from the Backend team

1. **Auth endpoint paths** for: Login, Sign Up, Forgot Password, OTP
   verification, Reset Password (e.g. `POST /auth/login` — exact prefix
   unconfirmed; could be under the Gateway's own route prefix rather than
   `/auth/...` directly).
2. **Request body field names** for each of the above (e.g. is it
   `email`/`password`, or `userName`/`pwd`, does Sign Up send `gender` as
   a string enum or an int?).
3. **Response shape** for a successful Login/Sign Up: is the token field
   called `token`, `accessToken`, `jwt`? Is there a `refreshToken`? Is the
   user object nested (`{ "user": {...}, "token": "..." }`) or flat?
4. **Error response shape**: does a failed request return
   `{ "message": "..." }`, ASP.NET Core's default `{ "title": "...",
   "status": ... }` ProblemDetails, or something else? What status code
   does "email already registered" (Sign Up) or "wrong OTP" return —
   409? 400? 422?
5. **Token behavior**: expiration time, whether a refresh token exists
   and how to use it, and the exact `Authorization` header format
   (assumed `Bearer <token>` since the service is JWT-based — not
   confirmed against a real response).
6. **Swagger/OpenAPI URL**, if one is exposed (e.g. `/swagger`), once the
   backend is reachable — this alone would answer most of the above.
7. **Whether the Gateway forwards Auth routes under a prefix** (e.g.
   `/auth/*` → Auth service) or Auth is reachable at the Gateway's root.
8. **Test/seed credentials** for manual verification once wired up.
9. Confirmation of why the Docker Hub pulls for the `manaarnabil/*`
   images are timing out — worth checking whether those images are
   actually public, since a `denied: requested access...` error (auth
   problem) looks different from the `context deadline exceeded` (network
   timeout) seen so far; that distinction wasn't fully isolated because
   the pull never got far enough on a slow/unstable connection to tell.

## What's already built and ready (no further backend info needed)

- `core/network/api_client.dart` — `DioApiClient`, wraps every request/
  response in this codebase's own exception types, maps DioExceptions to
  `NetworkException`/`ApiException`.
- `core/network/dio_client_factory.dart` — configured `Dio` instance +
  `AuthorizationInterceptor` (attaches `Bearer <token>` when a token is
  stored) + debug-only request/response logging.
- `core/storage/secure_storage_service.dart` — encrypted token storage
  via `flutter_secure_storage`.
- `core/network/network_info.dart` — real connectivity check via
  `connectivity_plus`.
- `features/auth/data/datasources/auth_remote_data_source.dart` —
  structurally complete `AuthRemoteDataSourceImpl`, registered in DI,
  constructor-correct; only the endpoint path + request/response parsing
  per method is pending.
- `features/auth/data/repositories/auth_repository_impl.dart` — maps any
  `ApiException` by HTTP status code to the right `Failure` automatically;
  no repository change needed once the remote data source is filled in.

## The one-line activation switch

Once `AuthRemoteDataSourceImpl`'s methods call real endpoints, activate it
in `core/di/auth_injector.dart` by changing:

```dart
..registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl.new)
```

to:

```dart
..registerLazySingleton<AuthLocalDataSource>(() => sl<AuthRemoteDataSource>());
```

Nothing else — not `AuthRepositoryImpl`, not `AuthCubit`, not any View —
needs to change.
