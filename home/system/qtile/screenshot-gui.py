import gi
import subprocess
import os
from datetime import datetime
import tempfile
import time

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GObject, Gdk, GdkPixbuf

def notify(title, message, duration=3000):
    subprocess.run(["notify-send", title, message, "-t", str(duration)])

class ScreenshotApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="Screenshot GUI")
        self.set_default_size(800, 600)
        
        # Criar a pasta Imagens se não existir
        self.imagens_path = os.path.expanduser("~/Imagens")
        os.makedirs(self.imagens_path, exist_ok=True)
        
        # Caminho para a captura temporária
        self.temp_screenshot = os.path.join(tempfile.gettempdir(), "temp_screenshot.png")
        self.is_cropping = False
        
        # Captura inicial da tela
        self.capture_initial_screenshot()
        
        # Layout principal - divisão vertical
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(main_box)
        main_box.set_border_width(10)
        
        # Área de pré-visualização
        self.preview_frame = Gtk.Frame(label="Preview")
        main_box.pack_start(self.preview_frame, True, True, 0)
        
        # Scroll para a imagem
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        self.preview_frame.add(scroll)
        
        # Imagem de pré-visualização
        self.preview_image = Gtk.Image()
        self.load_preview_image()
        scroll.add(self.preview_image)

        accel_group = Gtk.AccelGroup()
        self.add_accel_group(accel_group)
        
        # Área de controles
        controls_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        main_box.pack_start(controls_box, False, False, 0)
        
        # Botões de ação
        btn_new = Gtk.Button(label="New Screenshot")
        btn_new.connect("clicked", self.on_new_capture)
        btn_new.add_accelerator("clicked", accel_group, Gdk.KEY_n, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE )
        controls_box.pack_start(btn_new, True, True, 0)
        
        btn_crop = Gtk.Button(label="Selection")
        btn_crop.connect("clicked", self.perform_selection_capture)
        btn_crop.add_accelerator("clicked", accel_group, Gdk.KEY_d, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE )
        controls_box.pack_start(btn_crop, True, True, 0)
        
        btn_save = Gtk.Button(label="Save")
        btn_save.connect("clicked", self.on_save)
        btn_save.add_accelerator("clicked", accel_group, Gdk.KEY_s, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE )
        controls_box.pack_start(btn_save, True, True, 0)
        
        btn_copy = Gtk.Button(label="Copy")
        btn_copy.connect("clicked", self.on_copy)
        btn_copy.add_accelerator("clicked", accel_group, Gdk.KEY_c, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE )
        controls_box.pack_start(btn_copy, True, True, 0)
        
        btn_quit = Gtk.Button(label="Quit")
        btn_quit.connect("clicked", self.quit)
        btn_quit.add_accelerator("clicked", accel_group, Gdk.KEY_q, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE)
        controls_box.pack_start(btn_quit, True, True, 0)

    

    def capture_initial_screenshot(self):
        """Captura a tela inicial ao abrir o aplicativo"""
        try:
            subprocess.run(["grim", self.temp_screenshot])
            print(f"Captura inicial salva em {self.temp_screenshot}")
        except Exception as e:
            print(f"Erro ao capturar tela inicial: {str(e)}")
            # Criar um arquivo de imagem vazio para evitar erros
            with open(self.temp_screenshot, 'wb') as f:
                pass

    def load_preview_image(self):
        """Carrega a imagem de pré-visualização"""
        try:
            if os.path.exists(self.temp_screenshot) and os.path.getsize(self.temp_screenshot) > 0:
                pixbuf = GdkPixbuf.Pixbuf.new_from_file(self.temp_screenshot)
                
                # Redimensionar preservando proporção se necessário
                win_width, win_height = self.get_size()
                img_width = pixbuf.get_width()
                img_height = pixbuf.get_height()
                
                # Calcular escala para caber na janela (80% do tamanho da janela)
                scale = min((win_width * 0.8) / img_width, (win_height * 0.8) / img_height)
                
                # Se for necessário redimensionar
                if scale < 1:
                    new_width = int(img_width * scale)
                    new_height = int(img_height * scale)
                    pixbuf = pixbuf.scale_simple(new_width, new_height, GdkPixbuf.InterpType.BILINEAR)
                
                self.preview_image.set_from_pixbuf(pixbuf)
                self.current_pixbuf = pixbuf  # Guardar referência para operações futuras
            else:
                self.preview_image.set_from_icon_name("image-missing", Gtk.IconSize.DIALOG)
        except Exception as e:
            print(f"Erro ao carregar imagem: {str(e)}")
            self.preview_image.set_from_icon_name("image-missing", Gtk.IconSize.DIALOG)

    def on_new_capture(self, widget):
        """Inicia uma nova captura"""
        dialog = Gtk.Dialog(
            title="Screenshot-GUI - New capture",
            parent=self,
            flags=0,
            buttons=(
                "Full Screen", Gtk.ResponseType.ACCEPT,
                "Selection", Gtk.ResponseType.YES,
                "Cancel", Gtk.ResponseType.CANCEL
            )
        )
        
        box = dialog.get_content_area()
        box.set_spacing(10)
        box.set_border_width(10)
        
        label = Gtk.Label(label="Options:")
        box.add(label)
        
        show_mouse_check = Gtk.CheckButton(label="Show mouse")
        box.add(show_mouse_check)
        
        dialog.show_all()
        response = dialog.run()
        
        show_mouse = show_mouse_check.get_active()
        dialog.destroy()
        
        if response == Gtk.ResponseType.ACCEPT:
            # Esconder completamente a janela
            self.hide()
            # Esperar para garantir que a janela esteja escondida
            while Gtk.events_pending():
                Gtk.main_iteration()
            time.sleep(0.2)  # Pequena pausa para garantir que a janela está escondida
            
            # Fazer a captura em um timeout para dar tempo de esconder a janela
            GObject.timeout_add(100, self.perform_fullscreen_capture, show_mouse)
        elif response == Gtk.ResponseType.YES:
            # Esconder completamente a janela
            self.hide()
            # Esperar para garantir que a janela esteja escondida
            while Gtk.events_pending():
                Gtk.main_iteration()
            time.sleep(0.2)  # Pequena pausa para garantir que a janela está escondida
            
            # Fazer a captura em um timeout para dar tempo de esconder a janela
            GObject.timeout_add(100, self.perform_selection_capture, show_mouse)

    def perform_fullscreen_capture(self, show_mouse=False):
        """Realiza captura de tela inteira"""
        try:
            grim_command = ["grim"]
            
            if show_mouse:
                grim_command.append("-c")
                
            grim_command.append(self.temp_screenshot)
            subprocess.run(grim_command)
            
            # Reexibir a janela
            self.show_all()
            self.load_preview_image()
            print("Captura de tela inteira realizada")
        except Exception as e:
            # Reexibir a janela em caso de erro
            self.show_all()
            print(f"Erro ao capturar tela inteira: {str(e)}")
        return False  # Para não repetir o timeout

    def perform_selection_capture(self, show_mouse=False):
        """Realiza captura de seleção"""
        try:
            # Capturar a região selecionada
            region = subprocess.check_output("slurp", text=True).strip()
            
            grim_command = ["grim", "-g", region]
            
            if show_mouse:
                grim_command.append("-c")
                
            grim_command.append(self.temp_screenshot)
            subprocess.run(grim_command)
            
            # Reexibir a janela
            self.show_all()
            self.load_preview_image()
            print("Captura de seleção realizada")
        except Exception as e:
            # Reexibir a janela em caso de erro
            self.show_all()
            print(f"Erro ao capturar seleção: {str(e)}")
        return False  # Para não repetir o timeout

    def on_crop(self, widget):
        """Permite recortar a imagem atual"""
        if self.is_cropping or not os.path.exists(self.temp_screenshot):
            return
            
        self.is_cropping = True
        
        # Criar uma cópia temporária da imagem atual para exibir e recortar
        temp_full_screenshot = os.path.join(tempfile.gettempdir(), "temp_full_screenshot.png")
        temp_cropped_screenshot = os.path.join(tempfile.gettempdir(), "temp_cropped_screenshot.png")
        
        # Copiar a imagem atual para um arquivo temporário
        subprocess.run(["cp", self.temp_screenshot, temp_full_screenshot])
        
        # Esconder completamente a janela
        self.hide()
        # Esperar para garantir que a janela esteja escondida
        while Gtk.events_pending():
            Gtk.main_iteration()
        time.sleep(0.2)  # Pequena pausa para garantir que a janela está escondida
        
        try:
            # Exibir a imagem atual em tela cheia usando swaybg
            bg_process = subprocess.Popen(["swaybg", "-i", temp_full_screenshot, "-m", "fill"])
            
            # Esperar um pouco para o fundo aparecer
            time.sleep(0.5)
            
            try:
                # Capturar a região selecionada pelo usuário
                region = subprocess.check_output("slurp", text=True).strip()
                
                # Usar grim para recortar a imagem completa com base na seleção
                # Isso cria uma nova imagem com apenas a região selecionada
                subprocess.run(["grim", "-g", region, "-s", "1", temp_cropped_screenshot])
                
                # Substituir a imagem original pela recortada
                subprocess.run(["mv", temp_cropped_screenshot, self.temp_screenshot])
                
                print(f"Imagem recortada com sucesso: região {region}")
            except subprocess.CalledProcessError:
                # O usuário cancelou o slurp, não fazer nada
                print("Recorte cancelado pelo usuário")
            finally:
                # Encerrar o processo de exibição de fundo
                bg_process.terminate()
                try:
                    bg_process.wait(timeout=1)
                except subprocess.TimeoutExpired:
                    bg_process.kill()
                
                # Tentar remover os arquivos temporários
                for temp_file in [temp_full_screenshot]:
                    try:
                        if os.path.exists(temp_file):
                            os.remove(temp_file)
                    except:
                        pass
        except Exception as e:
            print(f"Erro ao recortar imagem: {str(e)}")
        
        # Reexibir a janela
        self.show_all()
        self.load_preview_image()
        self.is_cropping = False

    def on_save(self, widget):
        """Salva a imagem atual na pasta Imagens"""
        try:
            filename = f"screenshot-{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.png"
            save_path = os.path.join(self.imagens_path, filename)
            
            # Copiar o arquivo temporário para o destino final
            subprocess.run(["cp", self.temp_screenshot, save_path])
            notify("SWScreenshot-GUI",f"Image saved in: {save_path}") 
            Gtk.main_quit()         
            print(f"Imagem salva em: {save_path}")
        except Exception as e:
            print(f"Erro ao salvar imagem: {str(e)}")
            
            error_dialog = Gtk.MessageDialog(
                transient_for=self,
                flags=0,
                message_type=Gtk.MessageType.ERROR,
                buttons=Gtk.ButtonsType.OK,
                text="Error"
            )
            error_dialog.format_secondary_text(str(e))
            error_dialog.run()
            error_dialog.destroy()

    def on_copy(self, widget):
        """Copia a imagem atual para a área de transferência"""
        try:
            # Usar wl-copy para copiar a imagem para o clipboard
            with open(self.temp_screenshot, "rb") as f:
                subprocess.run(["wl-copy"], stdin=f)
            
            notify("SWScreenshot-GUI","Image copied to clipboard.")
            Gtk.main_quit()  
            print("Imagem copiada para a área de transferência")
        except Exception as e:
            print(f"Erro ao copiar imagem: {str(e)}")
            
            error_dialog = Gtk.MessageDialog(
                transient_for=self,
                flags=0,
                message_type=Gtk.MessageType.ERROR,
                buttons=Gtk.ButtonsType.OK,
                text="Error"
            )
            error_dialog.format_secondary_text(str(e))
            error_dialog.run()
            error_dialog.destroy()

    def quit(self, widget):
        """Encerra o aplicativo"""
        # Remover arquivos temporários
        if os.path.exists(self.temp_screenshot):
            try:
                os.remove(self.temp_screenshot)
            except:
                pass
        Gtk.main_quit()

if __name__ == "__main__":
    app = ScreenshotApp()
    app.connect("destroy", Gtk.main_quit)
    app.show_all()
    Gtk.main()
