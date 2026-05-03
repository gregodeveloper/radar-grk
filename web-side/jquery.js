let isDragging = false;
let dragOffset = { x: 0, y: 0 };
const container = document.getElementById('radar-container');

window.addEventListener("message", function(event) {
    let data = event.data;

    // Ativar/Desativar Radar
    if (data.radar === true) {
        $("#radar-container").fadeIn(200);
    }
    if (data.radar === false) {
        $("#radar-container").fadeOut(200);
    }

    // Modo de Arrastar (Comando /radar)
    if (data.action === "dragMode") {
        if (data.state) {
            $("#drag-overlay").css("display", "flex");
        } else {
            $("#drag-overlay").hide();
        }
    }

    // Atualização de Dados Frontais
    if (data.radar === "update") {
        $("#veh-model").text(data.Model);
        $("#veh-plate").text(data.plate);

        // Alerta de Roubo Simplificado
        if (data.stolen) {
            $("#stolen-alert").css("display", "block");
            $("#radar-container").addClass("is-stolen");
        } else {
            $("#stolen-alert").hide();
            $("#radar-container").removeClass("is-stolen");
        }
    }

    // Limpar Dados
    if (data.radar === "clear") {
        $("#veh-model").text("AGUARDANDO...");
        $("#veh-plate").text("---");
        $("#stolen-alert").hide();
        $("#radar-container").removeClass("is-stolen");
    }
});

// Fechar modo Drag com a tecla ESC
document.onkeyup = function(data) {
    if (data.which == 27) { // 27 = ESC
        $.post(`https://${GetParentResourceName()}/closeDrag`, JSON.stringify({}));
        $("#drag-overlay").hide();
    }
};

// Lógica de Movimentação do Radar
const overlay = document.getElementById('drag-overlay');

overlay.addEventListener('mousedown', function(e) {
    isDragging = true;
    
    // Reseta a posição X para o mouse seguir perfeitamente
    container.style.transform = 'none'; 
    
    let rect = container.getBoundingClientRect();
    dragOffset.x = e.clientX - rect.left;
    dragOffset.y = e.clientY - rect.top;
});

window.addEventListener('mousemove', function(e) {
    if (isDragging) {
        let x = e.clientX - dragOffset.x;
        let y = e.clientY - dragOffset.y;
        
        container.style.left = x + 'px';
        container.style.top = y + 'px';
        container.style.bottom = 'auto'; // Solta a âncora do fundo
    }
});

window.addEventListener('mouseup', function() {
    isDragging = false;
});