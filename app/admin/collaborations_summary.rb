ActiveAdmin.register_page "collaborations_summary" do

  menu parent: "Colaboraciones", label: "Resumen de colaboraciones"

  content title: "Resumen de colaboraciones" do
    columns do
      column do 
        panel "Colaboraciones por tipo" do 
          render "graph_collaboration_type"
        end
      end
      column do 
        panel "Colaboraciones por frecuencia" do 
          render "graph_collaboration_frequency"
        end
      end
      column do 
        panel "Colaboraciones por cantidad" do 
          render "graph_collaboration_amount"
        end
      end
    end
    columns do
      column do 
        panel "Evolución de colaboraciones" do 
          render "graph_collaboration_evolution"
        end
      end
    end
    columns do 
      column do 
        panel "Resumen" do 
          render "resumen"
        end
      end
    end 
  end

end
