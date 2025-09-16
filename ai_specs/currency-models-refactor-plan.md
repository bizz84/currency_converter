# Currency Models Refactoring Plan

## Overview
This document outlines the comprehensive refactoring of the currency data models and their usage throughout the Currency Converter application, transforming from string-based currency codes to a strongly-typed Currency enum system.

## Motivation for Refactor

### Problems with Original Implementation
1. **Type Safety Issues**: Currency codes were represented as strings throughout the codebase, allowing invalid values to be passed without compile-time detection
2. **Data Redundancy**: Currency metadata (names, symbols, flags) was stored in multiple separate maps within `FakeDataProvider`
3. **Runtime Errors**: Invalid currency codes would only be discovered at runtime
4. **Poor Encapsulation**: Related currency data was scattered across different data structures
5. **No Single Source of Truth**: Currency information could become inconsistent between different maps

### Benefits of New Approach
1. **Compile-time Safety**: Using an enum ensures only valid currencies can be used
2. **Data Cohesion**: All currency metadata is encapsulated within a single Currency enum
3. **Better API Integration**: Automatic filtering of unsupported currencies from API responses
4. **Improved Developer Experience**: IDE autocomplete and compile-time validation
5. **Cleaner Code**: Reduced boilerplate and more expressive type signatures

## Alternatives Considered

### Option 1: Keep String-based System with Validation
- **Pros**: No breaking changes, flexible for new currencies
- **Cons**: Runtime validation overhead, no compile-time guarantees
- **Decision**: Rejected - doesn't address core type safety issues

### Option 2: Sealed Classes with Currency Subclasses
- **Pros**: Type safe, extensible
- **Cons**: Overly complex for fixed set of currencies
- **Decision**: Rejected - unnecessary complexity

### Option 3: Currency Enum with Properties (Chosen)
- **Pros**: Type safe, simple, all data co-located, compile-time validation
- **Cons**: Adding currencies requires code changes
- **Decision**: Accepted - best balance of safety and simplicity

### Option 4: Hybrid Approach (Map<String, Currency>)
- **Pros**: Type safe internally, flexible API
- **Cons**: Still allows invalid strings at boundaries
- **Decision**: Partially adopted - used for API responses but converted to enum internally

## Implementation Plan

### Phase 1: Create Currency Infrastructure ✅
**Objective**: Establish the foundation for the new currency system

1. **Create Currency Enum** 
   - Define enum with all supported currencies
   - Add properties: `desc` (description), `symbol`, `flag`
   - Include all 36 currencies from original implementation

2. **Add Currency Helper Methods**
   - Implement `Currency.from(String code)` factory method
   - Return nullable to handle unknown currency codes safely
   - Use `firstOrNull` for cleaner null handling

3. **Remove FakeDataProvider Class**
   - Delete the class entirely
   - Consolidate all currency data into the enum

### Phase 2: Update Data Models ✅
**Objective**: Modify data models to work with Currency enum

1. **Update Currencies Model**
   - Change from `Map<String, String>` to `Set<Currency>`
   - Update `fromJson` to filter and convert API responses
   - Only include currencies defined in our enum
   - Add comprehensive documentation explaining the approach

2. **Add TODOs for CurrencyRates**
   - Mark `base` field for future conversion to Currency
   - Mark `rates` map for potential future conversion
   - Keep as strings for now to maintain API compatibility

3. **Update TimeSeriesRates**
   - Add similar TODOs for future conversion
   - Maintain current structure for API compatibility

### Phase 3: Update Network Layer ✅
**Objective**: Modify API client to use Currency types

1. **Update FrankfurterClient Methods**
   - Change parameters from `String` to `Currency` and `List<Currency>`
   - `getLatestRates`: Accept `Currency base` and `List<Currency>? to`
   - `getHistoricalRates`: Accept `Currency base` and `List<Currency>? to`
   - `getTimeSeriesRates`: Accept `Currency? base` and `List<Currency>? to`

2. **Add Helper Method for DRY Code**
   - Create `_currenciesToString` private method
   - Convert `List<Currency>?` to comma-separated string
   - Reuse across all API methods

3. **Update Providers**
   - Modify `latestRates` provider to accept Currency parameter
   - Update `exchangeRate` provider to use Currency types
   - Fix property access to use `.name` for map lookups

### Phase 4: Update UI Components ✅
**Objective**: Refactor all UI components to use Currency type

1. **Update Widget Parameters**
   - `CurrencySelector`: Change `String currency` to `Currency currency`
   - `CurrencyConversionTile`: Use `Currency` for both base and target
   - `CurrencyPickerDialog`: Accept `Currency?` and `List<Currency>?`

2. **Update ConvertScreen**
   - Change state variables to use Currency types
   - Update `baseCurrency` from `String` to `Currency`
   - Change `targetCurrencies` from `List<String>` to `List<Currency>`
   - Update all method signatures accordingly

3. **Fix Property Access**
   - Update all widgets to access enum properties directly
   - Use `currency.flag`, `currency.name`, `currency.desc`
   - Remove calls to removed helper methods

### Phase 5: Update Tests ✅
**Objective**: Ensure all tests work with new Currency system

1. **Import Currency Enum**
   - Add import statement to test files
   - Update all test method calls

2. **Update Test Parameters**
   - Replace string literals with Currency enum values
   - Update tests to use `List<Currency>` where appropriate
   - Fix test for multiple currencies (e.g., `[Currency.GBP, Currency.EUR]`)

3. **Verify Test Coverage**
   - Ensure all tests pass
   - Check that Currency.from() handles null cases
   - Validate error handling for unknown currencies

### Phase 6: Code Cleanup and Optimization ✅
**Objective**: Improve code quality and remove redundancy

1. **Remove Unused Imports**
   - Clean up import statements across all files
   - Remove references to deleted FakeDataProvider

2. **Add Documentation**
   - Document the Currencies class with rationale
   - Explain trade-offs and design decisions
   - Add inline comments where helpful

3. **Final Testing**
   - Run full test suite
   - Execute flutter analyze
   - Verify app functionality manually

## Migration Strategy

### For Existing Code
1. **Gradual Migration**: Update one component at a time
2. **Maintain Backwards Compatibility**: Keep string conversion at API boundaries
3. **Test Continuously**: Run tests after each phase

### For New Features
1. **Use Currency Enum**: All new code should use the Currency type
2. **Avoid String Codes**: Never pass currency codes as strings internally
3. **Validate at Boundaries**: Convert strings to Currency at entry points

## Rollback Plan
If issues arise:
1. Git revert to main branch
2. Address specific issues
3. Re-implement in smaller chunks

## Future Enhancements

### Short Term
1. Convert `CurrencyRates.base` from String to Currency
2. Consider converting rates map keys to use Currency enum

### Long Term
1. Dynamic currency loading from API with local enum fallback
2. Support for cryptocurrency additions
3. Currency metadata caching strategy

## Lessons Learned
1. **Type Safety First**: Strong typing prevents entire classes of bugs
2. **Data Cohesion**: Keep related data together
3. **Incremental Refactoring**: Small, tested changes are safer
4. **Documentation Matters**: Clear rationale helps future developers

## Implementation Status
- ✅ Phase 1: Currency Infrastructure - Complete
- ✅ Phase 2: Data Models - Complete  
- ✅ Phase 3: Network Layer - Complete
- ✅ Phase 4: UI Components - Complete
- ✅ Phase 5: Tests - Complete
- ✅ Phase 6: Cleanup - Complete

**Total Changes**: 13 files modified, 197 insertions(+), 233 deletions(-)
**Net Result**: Cleaner, safer, more maintainable code with fewer lines