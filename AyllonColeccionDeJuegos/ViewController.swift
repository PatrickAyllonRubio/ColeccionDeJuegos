//
//  ViewController.swift
//  AyllonColeccionDeJuegos
//
//  Created by Patrick Hugo Ayllòn Rubio on 30/09/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var juegos: [Juego] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true 
    }

    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            juegos = try context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        } catch {
            print("Error al cargar los juegos")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.detailTextLabel?.text = "Categoría: \(juego.categoria ?? "Sin categoría")"
        cell.imageView?.image = UIImage(data: juego.imagen!)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "juegoSegue" {
            let siguienteVC = segue.destination as! JuegosViewController
            siguienteVC.juego = sender as? Juego
        }
    }

    // Método para eliminar un elemento con "swipe to delete"
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juegos[indexPath.row])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // Actualizar la lista y la tabla
            do {
                juegos = try context.fetch(Juego.fetchRequest())
                tableView.reloadData()
            } catch {
                print("Error al eliminar el juego")
            }
        }
    }

    // Método para mover elementos en la tabla
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let movedJuego = juegos.remove(at: fromIndexPath.row)
        juegos.insert(movedJuego, at: toIndexPath.row)
        tableView.reloadData()
    }
}


