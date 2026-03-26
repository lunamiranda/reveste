const std = @import("std");
const spider = @import("spider");

fn healthCheck(alloc: std.mem.Allocator, _: *spider.Request) !spider.Response {
    var response = try spider.Response.json(alloc, .{ .msg = "pong" });
    response.status = .ok;
    return response;
}

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();
    const io = init.io;

    const server = try spider.Spider.init(arena, io, "0.0.0.0", 8081, .{
        .layout = @embedFile("views/layout.html"),
    });
    defer server.deinit();

    _ = server.get("/", indexHandler);
    _ = server.get("/up", healthCheck);
    _ = server.get("/problema", problemaHandler);
    _ = server.get("/solucao", solucaoHandler);
    _ = server.get("/como-funciona", comoFuncionaHandler);
    _ = server.get("/impacto", impactoHandler);
    _ = server.get("/sobre", sobreHandler);
    _ = server.get("/doar", doarPageHandler);
    _ = server.post("/doar", doarHandler);
    _ = server.get("/agendar", agendarHandler);
    _ = server.post("/agendar", agendarSubmitHandler);
    _ = server.get("/api/ultima-doacao", ultimaDoacaoHandler);

    _ = server.get("/assets/*", spider.static.serve);

    server.listen() catch |err| {
        std.log.err("server error: {}", .{err});
        return err;
    };
}

fn indexHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const view = @embedFile("views/index.html");
    return spider.renderView(alc, req, view, .{ .current = "/" });
}

fn problemaHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const view = @embedFile("views/problema.html");
    return spider.renderView(alc, req, view, .{ .current = "/problema" });
}

fn solucaoHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const view = @embedFile("views/solucao.html");
    return spider.renderView(alc, req, view, .{ .current = "/solucao" });
}

fn comoFuncionaHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const view = @embedFile("views/como-funciona.html");
    return spider.renderView(alc, req, view, .{ .current = "/como-funciona" });
}

fn impactoHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const view = @embedFile("views/impacto.html");
    return spider.renderView(alc, req, view, .{ .current = "/impacto" });
}

fn sobreHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const view = @embedFile("views/sobre.html");
    return spider.renderView(alc, req, view, .{ .current = "/sobre" });
}

fn doarPageHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const view = @embedFile("views/doar.html");
    return spider.renderView(alc, req, view, .{ .current = "/doar" });
}

fn ultimaDoacaoHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const partial = @embedFile("views/partials/ultima-doacao.html");
    return spider.renderView(alc, req, partial, .{});
}

fn doarHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const partial = @embedFile("views/partials/doacao-sucesso.html");
    return spider.renderView(alc, req, partial, .{});
}

fn agendarHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const partial = @embedFile("views/partials/agendar-form.html");
    return spider.renderView(alc, req, partial, .{});
}

fn agendarSubmitHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const partial = @embedFile("views/partials/agendar-sucesso.html");
    return spider.renderView(alc, req, partial, .{});
}
