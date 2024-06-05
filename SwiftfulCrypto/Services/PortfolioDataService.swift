//
//  PortfolioDataService.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 05/06/2024.
//

import CoreData

class PortfolioDataService {
    @Published var savedEntities: [PortfolioEntity] = []
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading CoreData: \(error)")
            }
            self.fetchPortfolio()
        }
    }
    
    // MARK: - Public
    
    func updatePortfolio(coin: Coin, amount: Double) {
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity, amount: amount)
            } else {
                delete(entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: - Private
    
    private func fetchPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching Portfolio Entities: \(error)")
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(_ entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(_ entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to CoreData: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        fetchPortfolio()
    }
}
