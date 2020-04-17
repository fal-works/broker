package broker.collision.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sneaker.types.Maybe;
import sneaker.macro.Types;
import sneaker.macro.ContextTools;
import sneaker.macro.MacroLogger.*;
import broker.collision.cell.PartitionLevel;

using sneaker.macro.extensions.ExprExtension;

class CollisionSpaceMacro {
	public static macro function build(): Null<Fields> {
		final localClassResult = ContextTools.getLocalClassRef();
		if (localClassResult.isFailedWarn()) return null;
		final localClassRef = localClassResult.unwrap();
		final localClass = localClassRef.get();
		final localClassPathString = localClassRef.toString();

		final maybeParameters = getMetadataParameters(localClass);
		if (maybeParameters.isNone()) return null;
		final parameters = maybeParameters.unwrap();

		final leftX: Int = parameters.leftTop.x;
		final topY: Int = parameters.leftTop.y;
		final rightX: Int = parameters.rightBottom.x;
		final bottomY: Int = parameters.rightBottom.y;
		final levelValue: Int = parameters.level;
		final gridSize: Int = 1 << levelValue;
		final leafCellPositionFactorX: Float = gridSize / (rightX - leftX);
		final leafCellPositionFactorY: Float = gridSize / (bottomY - topY);

		final classDef = macro class CollisionSpace {
			/**
				The x coordinate of the left-top point of the entire space.
			**/
			public static final leftX: Int = $v{leftX};

			/**
				The y coordinate of the left-top point of the entire space.
			**/
			public static final topY: Int = $v{topY};

			/**
				The x coordinate of the right-bottom point of the entire space.
			**/
			public static final rightX: Int = $v{rightX};

			/**
				The y coordinate of the right-bottom point of the entire space.
			**/
			public static final bottomY: Int = $v{bottomY};

			/**
				The finest `PartitionLevel` value of `this` space (i.e. the depth of quadtrees).
			**/
			public static var partitionLevel(
				get,
				never
			): broker.collision.cell.PartitionLevel;

			/**
				The size of the space grid determined by `this.partitionLevel`.
			**/
			public static var gridSize(get, never): Int;

			/**
				Factor for calculating the position of a leaf cell
				(i.e. a cell in the finest partition level) in the space grid.
			**/
			public static var leafCellPositionFactorX(get, never): Float;

			/**
				Factor for calculating the position of a leaf cell
				(i.e. a cell in the finest partition level) in the space grid.
			**/
			public static var leafCellPositionFactorY(get, never): Float;

			/**
				@return The local index of the leaf `Cell` that contains the position `x, y`.
			**/
			static inline function getLeafCellLocalIndex(
				x: Float,
				y: Float
			): broker.collision.cell.LocalCellIndex {
				return if (x < leftX || x >= rightX || y < topY || y >= bottomY) {
					broker.collision.cell.LocalCellIndex.none;
				} else {
					final cellPositionX = banker.type_extension.FloatExtension.toInt((x - leftX) * leafCellPositionFactorX);
					final cellPositionY = banker.type_extension.FloatExtension.toInt((y - topY) * leafCellPositionFactorY);

					final indexValue = banker.types.Bits.zip(
						banker.types.Bits.from(cellPositionX),
						banker.types.Bits.from(cellPositionY)
					);

					new broker.collision.cell.LocalCellIndex(indexValue.toInt());
				}
			}

			/**
				@return New `Quadtree` with the specified `PartitionLevel`.
			**/
			public static inline function createQuadtree(): broker.collision.Quadtree {
				return new broker.collision.Quadtree(partitionLevel);
			}

			/**
				@return `GlobalCellIndex` of the finest `Cell` that contains the given AABB.
			**/
			public static inline function getCellIndex(
				leftX: Float,
				topY: Float,
				rightX: Float,
				bottomY: Float
			): broker.collision.cell.GlobalCellIndex {
				final leftTop = getLeafCellLocalIndex(leftX, topY);
				final rightBottom = getLeafCellLocalIndex(rightX, bottomY);

				return if (leftTop.isNone() && rightBottom.isNone()) {
					broker.collision.cell.GlobalCellIndex.none;
				} else {
					var aabbLevel: broker.collision.cell.PartitionLevel;
					var aabbLocalIndex: broker.collision.cell.LocalCellIndex;

					if (leftTop == rightBottom) {
						aabbLevel = partitionLevel;
						aabbLocalIndex = leftTop;
					} else {
						aabbLevel = broker.collision.cell.LocalCellIndex.getAabbLevel(
							leftTop,
							rightBottom,
							partitionLevel
						);
						final largerLeafCellIndex = broker.collision.cell.LocalCellIndex.max(
							leftTop,
							rightBottom
						); // For avoiding `-1`
						aabbLocalIndex = largerLeafCellIndex.inRoughLevel(
							partitionLevel,
							aabbLevel
						);
					}

					aabbLocalIndex.toGlobal(aabbLevel);
				}
			}

			static extern inline function get_partitionLevel()
				return new broker.collision.cell.PartitionLevel($v{levelValue});

			static extern inline function get_gridSize()
				return $v{gridSize};

			static extern inline function get_leafCellPositionFactorX()
				return $v{leafCellPositionFactorX};

			static extern inline function get_leafCellPositionFactorY()
				return $v{leafCellPositionFactorY};
		};

		final buildFields = Context.getBuildFields();
		return buildFields.concat(classDef.fields);
	}

	static function validParameterLength(meta: MetadataEntry, validLength: Int): Bool {
		final params = meta.params;
		if (params == null) {
			warn("Missing parameters", meta.pos);
			return false;
		}

		return switch (params.length) {
			case n if (n < validLength):
				warn("Not enough parameters", meta.pos);
				false;
			case n if (n > validLength):
				warn("Too many parameters", meta.pos);
				false;
			default:
				true;
		}
	}

	static function getMetadataParameters(localClass: ClassType): Maybe<{
		leftTop: { x: Int, y: Int },
		rightBottom: { x: Int, y: Int },
		level: Int
	}> {
		var leftTop: Maybe<{ x: Int, y: Int }> = Maybe.none();
		var rightBottom: Maybe<{ x: Int, y: Int }> = Maybe.none();
		var level: Maybe<Int> = Maybe.none();

		for (meta in localClass.meta.get()) {
			final params = meta.params;

			switch meta.name {
				case ':broker.leftTop' | ':broker_leftTop':
					if (!validParameterLength(meta, 2)) return null;
					final xResult = params[0].getIntLiteralValue();
					if (xResult.isFailedWarn()) return null;
					final yResult = params[1].getIntLiteralValue();
					if (yResult.isFailedWarn()) return null;
					leftTop = { x: xResult.unwrap(), y: yResult.unwrap() };
				case ':broker.rightBottom' | ':broker_rightBottom':
					if (!validParameterLength(meta, 2)) return null;
					final xResult = params[0].getIntLiteralValue();
					if (xResult.isFailedWarn()) return null;
					final yResult = params[1].getIntLiteralValue();
					if (yResult.isFailedWarn()) return null;
					rightBottom = { x: xResult.unwrap(), y: yResult.unwrap() };
				case ':broker.partitionLevel' | ':broker_partitionLevel':
					if (!validParameterLength(meta, 1)) return null;
					final levelResult = params[0].getIntLiteralValue();
					if (levelResult.isFailedWarn()) return null;
					level = levelResult.toMaybe();
				default:
			}
		}

		if (leftTop.isNone()) {
			warn("Missing metadata: @:broker.leftTop");
			return null;
		}

		if (rightBottom.isNone()) {
			warn("Missing metadata: @:broker.rightBottom");
			return null;
		}

		if (level.isNone()) {
			warn("Missing metadata: @:broker.partitionLevel");
			return null;
		}

		return {
			leftTop: leftTop.unwrap(),
			rightBottom: rightBottom.unwrap(),
			level: level.unwrap()
		};
	}
}
#end
