/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package gestor.de.bibliotecas;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.JOptionPane;

/**
 *
 * @author df335
 */
public class Usuario {
    public void crearusuario(String nombre , String correo , String contraseña){
        String nuevo = "INSERT INTO usuarios (nombre, correo, password, rol) VALUES (?, ?, ?, 'cliente')";
        
        try{
           Connection con = Conexion.conectar();
           PreparedStatement ps = con.prepareStatement(nuevo);
           ps.setString(1, nombre);
           ps.setString(2, correo);
           ps.setString(3, contraseña);
           ps.executeUpdate();
           JOptionPane.showMessageDialog(null, "Cuenta creada correctamente.");
        } 
        catch(SQLException ex)
        {
            JOptionPane.showMessageDialog(null, "Error al crear cuenta.");
        }
    }
    
    public void iniciarsesion(String correo, String contraseña){
        String acceder = "SELECT rol FROM usuarios WHERE correo=? AND password=?";
        
        try(Connection con = Conexion.conectar();
            PreparedStatement ps = con.prepareStatement(acceder)){
            ps.setString(1, correo);
            ps.setString(2, contraseña);
            
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                JOptionPane.showMessageDialog(null,"Inicio de sesion correcto.");
            } else {
                JOptionPane.showMessageDialog(null, "Datos incorrectos.");
            }
        }catch(SQLException e){
          JOptionPane.showMessageDialog(null,"Error al iniciar sesion.");  
        }
            
    }
    
}
