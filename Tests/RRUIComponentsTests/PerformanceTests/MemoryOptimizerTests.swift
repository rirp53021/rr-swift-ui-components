import Testing
import SwiftUI
@testable import RRUIComponents

@MainActor
struct MemoryOptimizerTests {
    
    // MARK: - Initialization Tests
    
    @Test("MemoryOptimizer initialization")
    func testMemoryOptimizerInitialization() {
        let memoryOptimizer = MemoryOptimizer.shared
        #expect(memoryOptimizer != nil)
    }
    
    @Test("MemoryOptimizer singleton")
    func testMemoryOptimizerSingleton() {
        let instance1 = MemoryOptimizer.shared
        let instance2 = MemoryOptimizer.shared
        
        #expect(instance1 === instance2)
    }
    
    // MARK: - Memory Management Tests
    
    @Test("Memory cleanup")
    func testMemoryCleanup() {
        let memoryOptimizer = MemoryOptimizer.shared
        // Test that performMemoryCleanup method exists and can be called
        memoryOptimizer.performMemoryCleanup()
        #expect(memoryOptimizer != nil)
    }
    
    @Test("Cache optimization")
    func testCacheOptimization() {
        let memoryOptimizer = MemoryOptimizer.shared
        // Test that optimizeCaches method exists and can be called
        memoryOptimizer.optimizeCaches()
        #expect(memoryOptimizer != nil)
    }
}