//
//  Persona.swift
//  AppDemo
//
//  Created by STI on 09/12/16.
//  Copyright © 2016 integrait. All rights reserved.
//

import CoreData
import UIKit

extension Persona
{
    class func fetch() -> NSFetchRequest<Persona>
    {
        return fetchRequest()
    }
    
    class func agregarTodos(datos : [Dictionary<String, Any?>]) -> (agregados: Int, modificados: Int, errores: Int)
    {
        var agregados = 0
        var modificados = 0
        var errores = 0
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for dato in datos
        {
            let id = dato["id"] as? Int ?? -1
            let nombre = dato["nombre"] as? String ?? ""
            let edad = dato["edad"] as? Int ?? -1
            let genero = dato["genero"] as? String ?? ""
            let foto = dato["foto"] as? String ?? ""
            
            if id == -1
            {
                errores = errores + 1
            } else{
                //let persona = Persona(context : context)
                let persona = selectId(id: id) ?? Persona(context : context)
                persona.id = Int64(id)
                persona.nombre = nombre
                persona.edad = Int16(edad)
                persona.foto = foto
                persona.genero = genero
                
                do {
                    if persona.isUpdated
                    {
                        print("Actualizando Dato: \(nombre)")
                        modificados = modificados + 1
                    }else{
                        agregados = agregados + 1
                        print("Agregando Dato: \(nombre)")
                    }
                    
                    
                    try context.save()
                } catch {
                    print("error guardando \(nombre)")
                }
            }
            
        }
        
        return (agregados, modificados, errores)
    }
    
    
    class func selectTodos() -> [Persona]
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = Persona.fetch()
        
        let sort = NSSortDescriptor(key : "edad", ascending : true)
        
        request.sortDescriptors = [sort]
        
        var personas = [Persona]()
        
        do{
            personas = try context.fetch(request) as [Persona]
        } catch{
            print("Error conla consulta. \(error)")
        }
        
        return personas
    }
    
    class func selectNombre(nombre: String) -> [Persona]
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = Persona.fetch()
        
        let predicado = NSPredicate(format : "nombre == %@ ", nombre)
        
        request.predicate = predicado
        var personas = [Persona]()
        
        do{
            personas = try context.fetch(request) as [Persona]
        } catch{
            print("Error conla consulta. \(error)")
        }
        
        return personas
    }
    
    class func selectId(id: Int) -> Persona?
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = Persona.fetch()
        
        let predicado = NSPredicate(format : "id == %ld ", id)
        
        request.predicate = predicado
        var personas = [Persona]()
        
        do{
            personas = try context.fetch(request) as [Persona]
        } catch{
            print("Error conla consulta. \(error)")
        }
        
        return personas.first
    }
    
    class func eliminar(persona: Persona)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate)
        context.persistentContainer.viewContext.delete(persona)
        context.saveContext()
    }
}
