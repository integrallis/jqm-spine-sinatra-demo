module Comida
  class ComidaWebApp
    module Views
      class Layout < Mustache
        def title 
          @title || "Welcome to Comida"
        end
        def ob
          "\{\{"
        end
        def cb
          "\}\}"
        end
      end
    end
  end
end
