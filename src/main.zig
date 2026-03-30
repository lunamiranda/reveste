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

    server
        .get("/", indexHandler)
        .get("/up", healthCheck)
        .get("/problema", problemaHandler)
        .get("/solucao", solucaoHandler)
        .get("/como-funciona", comoFuncionaHandler)
        .get("/sobre", sobreHandler)
        .get("/doar", doarPageHandler)
        // .post("/doar", doarHandler) // comentado temporariamente
        .get("/agendar", agendarHandler)
        .post("/agendar", agendarSubmitHandler)
        .get("/api/ultima-doacao", ultimaDoacaoHandler)
        .get("/assets/*", spider.static.serve)
        .listen() catch |err| {
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
    const view = @embedFile("views/doar.html");
    return spider.renderView(alc, req, view, .{ .current = "/doar" });
}

fn agendarHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const partial = @embedFile("views/partials/agendar-form.html");
    return spider.renderView(alc, req, partial, .{});
}

fn agendarSubmitHandler(alc: std.mem.Allocator, req: *spider.Request) !spider.Response {
    const partial = @embedFile("views/partials/agendar-sucesso.html");
    return spider.renderView(alc, req, partial, .{});
}
