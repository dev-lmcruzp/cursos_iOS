//
//  ViewController.swift
//  AppDemo
//
//  Created by STI on 05/12/16.
//  Copyright © 2016 integrait. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetalleViewControllerDelegate, AgregarViewControllerDelegate {
 
    //MARK: - Declaraciones
    var filaSeleccionada = -1
    var datos = [("Luis", 24), ("Miguel", 25)]
    var esEdicion : Bool = false

    
    @IBOutlet weak var btnBoton: UIButton!
    @IBOutlet weak var tblTabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return datos.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let eliminar = UITableViewRowAction(style: .destructive, title: "Borrar", handler: borrarFila)
        let editar = UITableViewRowAction(style: .normal, title: "Editar", handler: editarFila)
        return [eliminar, editar]
    }
    
    /*
     let alert = UIAlertController(title: "Error", message: "Los campos introducidos no son validos.", preferredStyle: .actionSheet)
     let defaultAction = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in })
     let defaultActionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: { (UIAlertAction) in
     self.navigationController!.popViewController(animated: true)
     })
     alert.addAction(defaultAction)
     alert.addAction(defaultActionCancel)
     
     present(alert, animated:  true, completion: { })
     */
    
    func borrarFila(sender: UITableViewRowAction, indexPath: IndexPath ){
        datos.remove(at: indexPath.row)
        tblTabla.reloadData()
    }
    
    func editarFila(sender: UITableViewRowAction, indexPath: IndexPath ){
        esEdicion = true
        filaSeleccionada = indexPath.row
        performSegue(withIdentifier: "AgregarSegue", sender: sender)
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    @IBAction func btnAgregar_Click(_ sender: Any) {
        performSegue(withIdentifier: "AgregarSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let filaInpar = (indexPath.row % 2 == 0)
        let proto = filaInpar ? "proto1" : "proto2"
        
        let vista = tableView.dequeueReusableCell(withIdentifier: proto, for: indexPath) as! FilaTableViewCell
        
        if filaInpar{
            vista.lblDerecha.text = "\(datos[indexPath.row].1)"
            vista.lblIzquierda.text = datos[indexPath.row].0
        }else{
            vista.lblIzquierda.text = "\(datos[indexPath.row].1)"
            vista.lblDerecha.text = datos[indexPath.row].0
        }
        
        
        return vista
    }
    
    // MARK: - UIView Delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "DetalleSegue":
                let view = segue.destination as! DetalleViewController
                view.numeroDeFila = filaSeleccionada
                view.dato = datos[filaSeleccionada].0
                view.datoNumero = datos[filaSeleccionada].1
                view.delegado = self
                break
            case "AgregarSegue" :
                let view = segue.destination as! AgregarViewController
                if esEdicion
                {
                    view.fila = filaSeleccionada
                    view.edad = datos[filaSeleccionada].1
                    view.nombre = datos[filaSeleccionada].0
                    esEdicion = false
                }
                view.delegado = self
                break
            default:
                break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Fila \(indexPath.row)")
        filaSeleccionada = indexPath.row
        //DetalleSegue
        performSegue(withIdentifier: "DetalleSegue", sender: self)
    }
    
    // MARK - DetalleView Delegates
    func numeroCambiado(numero: Int) {
        print("Nùmero cambiado \(numero)")
        
        datos[numero].1 = datos[numero].1 + 1
        tblTabla.reloadData()
    }
    
    
    // MARK : - Agregar Delegates
    func agregarRegistro(nombre: String, edad: Int) {
        datos.append((nombre, edad))
        tblTabla.reloadData()
    }
    
    func modificarRegistro(nombre: String, edad: Int, fila : Int) {
        datos[fila].1 = edad
        datos[fila].0 = nombre
        tblTabla.reloadData()
    }

}
