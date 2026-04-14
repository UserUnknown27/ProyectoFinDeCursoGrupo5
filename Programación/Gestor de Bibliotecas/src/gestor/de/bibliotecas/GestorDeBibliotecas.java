/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMain.java to edit this template
 */
package gestor.de.bibliotecas;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;

/**
 *
 * @author df335
 */
public class GestorDeBibliotecas extends Application {
    
    @Override
    public void start(Stage primaryStage) {
    Pantalla pantalla = new Pantalla();
    pantalla.setVisible(true);
    Conexion conexion = new Conexion();
    conexion.conectar();
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        launch(args);
    }
    
}
