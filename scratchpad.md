# Project Scratchpad

## Current Task: Implement Manual Dependency Injection and Migrate from Dio to HTTP

### Progress
- [x] Removed code generation plugins
- [x] Analyzed current DI setup
- [x] Identified core components that need manual DI
- [ ] Implement manual DI setup
- [ ] Migrate from Dio to HTTP package

### Implementation Plan
1. [ ] Set up manual dependency injection
   - [x] Review existing DI configuration
   - [ ] Create manual service locator
     - [ ] Create `Dependencies` class to hold all dependencies
     - [ ] Initialize dependencies in `main.dart`
   - [ ] Register all dependencies manually
     - [ ] External services (SharedPreferences, HTTP client)
     - [ ] Data sources
     - [ ] Repositories
     - [ ] Use cases
     - [ ] BLoCs
   - [ ] Update widget tree to use manual DI
   - [ ] Remove GetIt dependency

2. [ ] Migrate from Dio to HTTP
   - [ ] Add http package to pubspec.yaml
   - [ ] Create HTTP client wrapper with error handling
     - [ ] Implement base HTTP client
     - [ ] Add interceptors for logging/error handling
   - [ ] Update ApiService to use HTTP client
     - [ ] Replace Dio methods with HTTP client
     - [ ] Update error handling
     - [ ] Update response parsing
   - [ ] Test all API endpoints
     - [ ] Product listing
     - [ ] Product details
     - [ ] Categories
     - [ ] Search

### Current Implementation Status
- Using GetIt for service location (to be replaced)
- Dio is currently the HTTP client (to be replaced with `http` package)
- Well-structured feature-based architecture
- Clear separation of concerns (data/domain/presentation)

### Next Steps
1. Create manual service locator implementation
   - Create `Dependencies` class
   - Initialize dependencies in `main.dart`
2. Replace Dio with HTTP package
   - Add `http` package
   - Create HTTP client wrapper
   - Update ApiService
3. Update all features to use manual DI
4. Test all features

### Branch Information
- Current Branch: manual-di-implementation
- Next Step: Create manual service locator

### Dependencies to Manage
1. **External Services**
   - SharedPreferences
   - HTTP Client
   - (Optional) Firebase services

2. **Data Layer**
   - Local data sources (CartLocalDataSource)
   - Remote data sources (ProductRemoteDataSource)
   - Repositories (CartRepository, ProductRepository)

3. **Domain Layer**
   - All use cases (GetProducts, AddToCart, etc.)

4. **Presentation Layer**
   - BLoCs (ProductBloc, CartBloc)
   - Services (ThemeService, etc.)

### Migration Risks
1. Ensure all dependencies are properly initialized before use
2. Handle async initialization of services
3. Maintain proper error handling during HTTP migration
4. Test thoroughly after each major change
